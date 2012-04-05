#!/bin/bash

#check paths 
SPLIT=/usr/bin/split
SORT=/usr/bin/sort

usage(){
        echo "Usage: $0 max_lines filename result_filename"
        echo "options: "
        echo "	max_lines - number of lines for file splitting"
        echo "	filename  - input file (not sorted)"
        echo "	result_filename - output file (sorted result)"
        echo
        echo "usage example: "
        echo "		./sorter.sh 1600000 items sorted_items" 
        exit 1
}

LNUM=$1
INPUT_FILE=$2
OUTPUT_FILE=$3
PATT=part

[[ $# -eq 0 ]] && usage

#split input files on parts
echo "Splitting input file: $INPUT_FILE on parts..." 
$SPLIT -d -a6 -l$LNUM $INPUT_FILE $PATT
FILES=`ls ${PATT}0*`

#sort splited files
for FILE in $FILES
do
       echo Sorting part: $FILE
       $SORT -n -o $FILE.sorted $FILE
done

#merge sorted files = sorted result
MERGE_FILES=`ls ${PATT}0*.sorted`

#merge sorted files
echo "Merging sorted parts..."
$SORT -n -o $OUTPUT_FILE -m $MERGE_FILES
echo "Finished"

