#!/usr/bin/env bash

# Script that creates a tsv-file containing band name, short description in danish, day they play, link to RF page, and link to youtube page

dato=$(date +%Y%m%d)
wget -O rf-lineup-$dato "https://www.roskilde-festival.dk/da/line-up/"
echo -e "Artist\tBeskrivelse\tDag\tRF-link\tYoutube" >beskrivelser.tsv
for i in $(cat rf-lineup-$dato | grep '<a href="/da/years/2019' | cut -d '"' -f2)
do
    band=$(echo $i | rev | cut -d "/" -f2 | rev | sed -e 's/&#248;/ø/g' -e 's/&#237;/í/g' -e 's/&#233;/é/g' -e 's/&#225;/á/g')
    wget -c -O band-$band "https://www.roskilde-festival.dk/da/years/2019/acts/$band/"
    beskrivelse=$(cat band-$band | grep '<h6>' | sed -e 's/.*<h6><strong>//' -e 's/.*<h6>//' -e 's-<em>--g' -e 's-</em>--g' | cut -d "<" -f1)
    tidspunkt=$(cat band-$band | sed "s/></>\n</g" | grep "ju.i 2019" | cut -d ">" -f2 | cut -d " " -f1)
    link=$(echo "https://www.roskilde-festival.dk/da/years/2019/acts/$band/")
    youtube=$(cat band-$band | sed "s/></>\n</g" | grep 'a href="https://www.youtube.com/channel' | cut -d '"' -f2)
    echo -e "$(echo $band | tr "-" " ")\t$beskrivelse\t$tidspunkt\t$link\t$youtube" >>beskrivelser.tsv
done
