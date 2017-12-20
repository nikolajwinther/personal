#!/bin/sh

# This script counts instances of firstnames and sorts them in boys and girls categories
# The inputfile should contain a list of names that wants to be sorted in gender parts
# cat *best | grep '<td class="kandidat">' | sed -n '2~3p' | cut -d ">" -f2 | cut -d " " -f1 >../kandidatfornavne
# Example:
# $ ./countAllGenderNames.sh arb-A-navne


if [ -z $1 ]
then
    echo 'Please enter a filename after calling the script'
    exit 1
fi
inputfile=$1
cd /home/nikolaj/nikolaj/datamining/valg/kv2017

rm -f arb-liste*1
pigecount1=0
drengecount1=0
vedikke1=0

for i in $(cat $inputfile)
do
    pigevar=$(grep -c "^$i$" pigenavne)
    drengevar=$(grep -c "^$i$" drengenavne)

    if [ $drengevar -gt 0 ]
    then
        drengecount1=$(expr $drengecount1 + 1)
        echo $i >>arb-listedreng1
    elif [ $pigevar -gt 0 ]
    then
        pigecount1=$(expr $pigecount1 + 1)
        echo $i >>arb-listepige1
    else
        vedikke1=$(expr $vedikke1 + 1)
        echo $i >>arb-listeunisex1
    fi
done

echo "drengecount1: $drengecount1"
echo "pigecount1: $pigecount1"
echo "vedikke1: $vedikke1"

rm -f arb-liste*2
pigecount2=0
drengecount2=0
vedikke2=0
for i in $(cat $inputfile)
do
    pigevar=$(grep -c "^$i$" pigenavne)
    drengevar=$(grep -c "^$i$" drengenavne)

    if [ $pigevar -gt 0 ]
    then
        pigecount2=$(expr $pigecount2 + 1)
        echo $i >>arb-listepige2
    elif [ $drengevar -gt 0 ]
    then
        drengecount2=$(expr $drengecount2 + 1)
        echo $i >>arb-listedreng2
    else
        vedikke2=$(expr $vedikke2 + 1)
        echo $i >>arb-listeunisex2
    fi
done

echo "drengecount2: $drengecount2"
echo "pigecount2: $pigecount2"
echo "vedikke2: $vedikke2"


