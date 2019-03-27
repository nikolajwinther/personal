#!/usr/bin/env bash

# Script that creates a tsv-file containing band name, short description in danish, day they play, link to RF page, and link to youtube page

dato=$(date +%Y%m%d)

for lang in da en
do
    #wget -O ${lang}-rf-lineup-$dato "https://www.roskilde-festival.dk/${lang}/line-up/"
    outputfile="${lang}-beskrivelser-$dato.tsv"
    echo -e "Artist\tBeskrivelse\tDag\tRF-link\tYoutube" >$outputfile
    for i in $(cat ${lang}-rf-lineup-$dato | grep "<a href=\"/${lang}/years/2019" | cut -d '"' -f2)
    do
        band=$(echo $i | rev | cut -d "/" -f2 | rev | sed -e 's/&#248;/ø/g' -e 's/&#237;/í/g' -e 's/&#233;/é/g' -e 's/&#225;/á/g' -e 's/&#240;/ð/g' -e 's/&#244;/ô/g')
        #wget -c -O ${lang}-band-$band "https://www.roskilde-festival.dk/${lang}/years/2019/acts/$band/"
        beskrivelse=$(cat ${lang}-band-$band | grep '<h6>' | sed -e 's/.*<h6><strong>//' -e 's/.*<h6>//' -e 's-<em>--g' -e 's-</em>--g' | cut -d "<" -f1)
        tidspunkt=$(cat ${lang}-band-$band | sed "s/></>\n</g" | grep "ju.[eiy] 2019" | cut -d ">" -f2 | cut -d " " -f1)
        link=$(echo "https://www.roskilde-festival.dk/${lang}/years/2019/acts/$band/")
        youtube=$(cat ${lang}-band-$band | sed "s/></>\n</g" | grep 'a href="https://www.youtube.com/channel' | cut -d '"' -f2)
        echo -e "$(echo $band | tr "-" " ")\t$beskrivelse\t$tidspunkt\t$link\t$youtube" >> $outputfile
    done
    sed -i 's/\&amp;/\&/g' $outputfile
done
