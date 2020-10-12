#!/bin/bash
SCRIPT_PATH="/here/dashboards-jsonnet"
for file in $SCRIPT_PATH/*.jsonnet
do 
    input=$(basename -- $file)
    output=$SCRIPT_PATH/${input%.*}.json
    echo "Converting $file into $output"
    jsonnet $file > $output
done