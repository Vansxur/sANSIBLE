#!/bin/bash

Audit_Name=$1

# Concatenate shadow files
for machine_folder in $(ls "results/$Audit_Name/");
do
  find results/$Audit_Name/"$machine_folder" -name "shadow" -print -exec cat {} >> results/$Audit_Name/shadows-for-john.txt \;
done

# Crack passwords
john results/$Audit_Name/shadows-for-john.txt -show
