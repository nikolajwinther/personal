#!/bin/bash

#https://www.procyclingstats.com/nation.php?id=dk&s=contract-riders&season=1980&level=wt&filter=Filter
function toline(){
    sed 's/></>\n</g'
}
# countries="dk nl be"
countries="be dk nl"
for country in $countries
do
    mkdir -p $country
    cd ${country}

    for level in uci wt pct ct
    do
        # echo level: $level
        for year in $(seq 1980 2019)
        do
            echo country year: $country $year
            if [[ ( $level = "uci" && $year -gt "2006" ) || ( $level = "wt" ) || ( $level = "pct" && $year -gt "1997" ) || ( $level = "ct" && $year -gt "2001" ) ]]
            then
                wget -c -q -O year-${level}-${year}.html "https://www.procyclingstats.com/nation.php?id=${country}&s=contract-riders&season=${year}&level=${level}&filter=Filter"
                for rider in $(cat year-${level}-${year}.html | toline | grep 'href="rider/' | cut -d '"' -f2)
                do
                    # echo rider: $rider
                    riderName=$(echo $rider | cut -d "/" -f2)
                    wget -c -q -O rider_${level}_${year}_${riderName}.html "https://www.procyclingstats.com/${rider}"
                done
                # ridersNo=$(cat year-${level}-${year}.html | toline | grep 'href="rider/' -c)
                # echo $year $ridersNo
            fi
        done
    done
    cd ..
done
