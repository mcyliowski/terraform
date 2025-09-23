#!/bin/bash
echo "[control]"
terraform output -raw control_node_public_ip | xargs -I{} echo "control-node ansible_host={} ansible_user=admin ansible_ssh_private_key_file=~/michal_cyliowski_test.pem"

echo "[managed]"
terraform output -raw managed_node_1_public_ip | xargs -I{} echo "managed-node-1 ansible_host={} ansible_user=admin ansible_ssh_private_key_file=~/michal_cyliowski_test.pem"
terraform output -raw managed_node_2_public_ip | xargs -I{} echo "managed-node-2 ansible_host={} ansible_user=admin ansible_ssh_private_key_file=~/michal_cyliowski_test.pem"

echo "[all:vars]"
echo "ansible_python_interpreter=/usr/bin/python3"

