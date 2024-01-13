#!/usr/bin/bash

while IFS= read -r line
do
    ls $1/${line}_*.jpg | shuf > $line.txt
    sed -i 's/^\(..\/\)\+//g' $line.txt
    nlines=$(wc -l $line.txt | cut -d' ' -f1)
    train=$(expr $3 \* $nlines / 100)
    val=$(expr $4 \* $nlines / 100)
    test=$(expr $nlines - $train - $val)
    head -n $train $line.txt >> train.txt
    tail -n +`expr $train + 1` $line.txt | head -n $val >> valid.txt
    tail -n $test $line.txt >> test.txt
done < $2
shuf train.txt -o train.txt
shuf valid.txt -o valid.txt
shuf test.txt -o test.txt

