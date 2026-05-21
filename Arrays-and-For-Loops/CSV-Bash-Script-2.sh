#!/bin/bash
 
csv_file="arrays_table.csv"
 
column_0=($(cut -d "," -f 1 $csv_file | tail -n +2))
column_1=($(cut -d "," -f 2 $csv_file | tail -n +2))
column_2=($(cut -d "," -f 3 $csv_file | tail -n +2))
 
echo "Displaying the first column:"
echo "${column_0[@]}"
