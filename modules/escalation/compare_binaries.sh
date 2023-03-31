#!/bin/bash

Audit_Name=$1;

Binaries_File="results/$Audit_Name/confirmed_suid.txt";

# Delete the Binaries file with binaries in case that the audit name is the same as previously
if [ -f "$Binaries_File" ]; then
  rm $Binaries_File;
fi

# Concatenate shadow files
for machine_folder in $(ls "results/$Audit_Name/" | grep -v ".txt" | grep -v ".json" );
do
  while read -r line; do
  binary_name=$(basename "$line")
  methods=$(jq -r ".$binary_name[]" "modules/escalation/database_binaries.json" 2>/dev/null)
  if echo "$methods" | grep -q "suid"; then
      echo "$binary_name" >> $Binaries_File
  fi
  done < results/$Audit_Name/$machine_folder/binaries.txt
done
