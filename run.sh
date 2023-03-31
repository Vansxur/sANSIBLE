#!/bin/bash

Audit_Name=$1

# Check if we passed name in arg, if not, ask in a prompt the name for the audit
if [[ -z $Audit_Name ]]; then
  echo -n "Enter audit name ( it will erase duplicates ): "
  read -r Audit_Name
fi

# Run Ansible with config files
ansible-playbook -i inventory.yaml playbook.yaml --timeout 60 --extra-vars "audit_folder=$Audit_Name"

# Start craking password session
cracking_password.sh $Audit_Name
