#!/bin/bash


output="filer/flat.json"

cd /home/nikolaj/nikolaj/datamining/valg/kv2017/wwwkv2017
municipalities=$(cat KV | sed 's/ href/\n href/g' | grep href | grep Endeligt | tee filer/municipality-table| cut -d '"' -f2 | cut -d "/" -f6 | tr -d "K.htm" | grep 101$)

#Udkommenter ved test
municipalities=$(cat KV | sed 's/ href/\n href/g' | grep href | grep Endeligt | tee filer/municipality-table | cut -d '"' -f2 | cut -d "/" -f6 | tr -d "K.htm")

cat km* | grep '<div class="table-like-cell col-xs-5">' | grep -v "parti-letter" | cut -d ">" -f2 | cut -d "<" -f1 | sort | uniq -d >filer/dublerede-valgte
cat km* | grep '<div class="table-like-cell col-xs-5">' | grep -v "parti-letter" | cut -d ">" -f2 | cut -d "<" -f1 | sort | uniq >filer/valgte

echo "[" > $output
for municipality in $municipalities
do
    municipalityNumber=$(echo $municipality | rev | cut -c 1-3 | rev)
    municipalityName=$(cat filer/municipality-table | grep $municipality | cut -d ">" -f2 | cut -d "<" -f1 | sed 's/ $//')
    allVotes=$(cat K$municipality.htm | tr ">" "\n" | grep "I alt afgivne stemmer:" -A2 | tail -1 | cut -d "<" -f1 | tr -d ".")
    churchMembership=$(cat filer/folkekirkemedlemsskab | grep $municipalityName | cut -f2)
    tax=$(cat filer/kommuneskat.tsv | grep $municipalityName | cut -f2)
    electionTurnout=$(cat K$municipality.htm | tr ">" "\n" | grep "Stemme pct" -A3 | grep percent | cut -d '"' -f4)
    echo Kigger paa kommune ${municipality} - $municipalityNumber - $municipalityName
    parties=$(ls -1 k${municipality}* | grep A)
    parties=$(ls -1 k${municipality}*)
    for party in $parties
    do
        partyName=$(cat $party | tr ">" "\n" | grep opstilling | sed 's/^ //' | tr ",(-" "\t"| cut -f1 | sed 's/ $//')
        electionSystem=$(cat $party | tr ">" "\n" | grep opstilling | rev | cut -d "-" -f1 | rev | cut -d "<" -f1 | sed 's/^ //')
        allPartyVotes=$(cat $party | tr ">" "\n" | grep "I alt stemmer:" -A2 | tail -1 | cut -d "<" -f1 | tr -d ".")
        listVotes=$(cat $party | tr ">" "\n" | grep "Listestemmer:" -A2 | tail -1 | cut -d "<" -f1 | tr -d ".")
        cat $party | grep '"table-like-cell col-xs-7 col-sm-6 col-md-6 col-lg-8"' | cut -d ">" -f2 | cut -d "<" -f1 >filer/arb-personer
        while read -r person
        do
            votes=$(cat $party | grep '"table-like-cell col-xs-7 col-sm-6 col-md-6 col-lg-8"' -A2 | grep "$person" -A1 | cut -d ">" -f2 | cut -d "<" -f1 | grep -v "$person" | tr -d ".")
            elected=$(cat km${municipality}* | grep "table-like-cell col-xs-5" | grep "$person" -c | sed 's/[1-9]/1/')
            firstname=$(echo "$person" | cut -d " " -f1)
#            isBoy=$(cat filer/drengenavne | grep -c "^$firstname$")
#            isGirl=$(cat filer/pigenavne | grep -c "^$firstname$")
#            isNeutral=$(cat filer/unisexnavne | grep -c "^$firstname$")
            isBoy=$(cat filer/drengenavne-2017 | grep -c "^$firstname$")
            isGirl=$(cat filer/pigenavne-2017 | grep -c "^$firstname$")
            isNeutral=$(cat filer/unisexnavne-2017 | grep -c "^$firstname$")

            gender=""
            if [ $isBoy -gt 0 ]
            then
                gender=$(echo $gender Male)
            fi
            if [ $isGirl -gt 0 ]
            then
                gender=$(echo $gender Female)
            fi
            if [ $isNeutral -gt 0 ]
            then
                gender=$(echo $gender Neutral)
            fi
            if [ $(echo $gender | wc -c) -eq 1 ]
            then
                gender=$(echo $gender Unknown)
            fi
            echo "{" >>$output
            echo "    \"name\": \"$person\"," >>$output
            echo "    \"votes\": $votes," >>$output
            echo "    \"party\": \"$partyName\"," >>$output
            echo "    \"allPartyVotes\": \"$allPartyVotes\"," >>$output
            echo "    \"listVotes\": \"$listVotes\"," >>$output
            echo "    \"electionSystem\": \"$electionSystem\"," >>$output
            echo "    \"elected\": $elected," >>$output
            echo "    \"gender\": \"$gender\"," >>$output
            echo "    \"tax\": \"$tax\"," >>$output
            echo "    \"churchMembership\": \"$churchMembership\"," >>$output
            echo "    \"electionTurnout\": \"$electionTurnout\"," >>$output
#            echo "    \"\": \"$\"," >>$output
#            echo "    \"\": \"$\"," >>$output
            echo "    \"municipality\": \"$municipalityName\"," >>$output
            echo "    \"allVotes\": \"$allVotes\"," >>$output
            echo "    \"municipalityNumber\": \"$municipalityNumber\"" >>$output
            echo "}," >>$output
        done < filer/arb-personer
    done
done
sed -i '$ s/.$//' $output
echo "]" >>$output

#Udkommenter ved drift
#cat $output
echo "cat wwwkv2017/$output | less"
