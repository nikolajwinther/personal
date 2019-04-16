#!/bin/bash

#This script requires that getRiders.sh har already been run

#shortcut list
function toline(){
    sed 's/></>\n</g'
}
function xmltostring(){
    cut -d ">" -f2 | cut -d "<" -f1
}

countries="be dk nl"
for country in $countries
do
    cd $country
    for year in $(seq 1980 2019)
    do
        echo ${year} | tee analyse-${year}
        # echo ${year}0\'erne
        no=1
        for month in $(locale mon | sed 's/;/ /g')
        do
            amount=$(cat rider_*_${year}* 2>/dev/null | toline | grep "Date of birth" | cut -d "/" -f3 | xmltostring | cut -d " " -f2 | grep -c $month)
            echo $amount | tee -a analyse-${year}
            # echo $no $amount
            no=$(expr $no + 1)
        done
        echo ""
    done
    paste analyse-* >analyse-all
    cd ..
done
