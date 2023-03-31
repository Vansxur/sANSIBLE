#!/bin/bash

Audit_Name=$1;
Report_File="results/$Audit_Name/report.json";

# Delete the John file with shadows in case that the audit name is the same as previously
if [ -f "$Report_File" ]; then
  rm $Report_File;
fi

machines_json="[]"

for machine_folder in results/"$Audit_Name"/*; do
  if [ -d "$machine_folder" ]; then
    machine_name=$(basename "$machine_folder")

    machine_json=$(jq -n --arg name "$machine_name" '{name: $name, files: {}}')

    while IFS="=" read -r filename fileinfo; do
      jq --arg filename "$filename" --arg fileinfo "$fileinfo" '.files += { ($filename): $fileinfo }' <<< "$machine_json"
    done < "$machine_folder/binaries.txt"

    # Ajouter l'objet JSON de la machine au tableau JSON
    machines_json=$(jq '. + ['"$machine_json"']' <<< "$machines_json")
  fi
done

# Ajouter le tableau JSON des machines à l'objet JSON principal
final_json=$(jq --argjson machines "$machines_json" '{machines: $machines}' < /dev/null)

# Écrire le fichier JSON final dans un fichier
echo "$final_json" > "results/$Audit_Name/report.json"
