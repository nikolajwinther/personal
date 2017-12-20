#!/bin/sh

#This script scrapes all content regarding the KV2017 election from kmdvalg.dk and places the files in a 
#folder named files

baseurl="https://www.kmdvalg.dk/KV/2017/"
#mkdir files
#cd files
cd /home/nikolaj/nikolaj/datamining/valg/kv2017/wwwkv2017
wget -c https://www.kmdvalg.dk/Main/Home/KV
municipalities=$(cat KV | sed 's/ href/\n href/g' | grep href | grep Endeligt | cut -d '"' -f2 | cut -d "/" -f6 | tr -d "K.htm")
for i in $municipalities
do
    wget -c "${baseurl}K${i}.htm"
    parties=$(cat K$i.htm | sed 's/ href/\n href/g' | grep href | grep $i | cut -d '"' -f2 | grep ^k)
    #echo $parties
    places=$(cat K$i.htm | sed 's/ href/\n href/g' | grep href | grep $i | cut -d '"' -f2 | grep ^K)
    #echo $places
    for party in $parties
    do
        wget -c "${baseurl}$party"
    done
    for place in $places
    do
        wget -c "${baseurl}$place"
        placeparties=$(cat $place | sed 's/ href/\n href/g' | grep href | grep $i | cut -d '"' -f2 | grep ^k)
        for placeparty in $placeparties
        do
            wget -c "${baseurl}$placeparty"
        done
    done
done

