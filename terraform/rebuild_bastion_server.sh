#!/bin/bash

# Script name: rebuild_bastion_server.sh

# Ask for the sudo password
read -s -p "Enter the sudo password: " SUDO_PASSWORD
echo

# Find the PID of the SSH tunnel
#PID=$(ps aux | grep "ssh -i concourse-k8s.pem -L 8080:localhost:8080" | grep -v "grep" | awk '{print $2}')
#
## If PID is not empty, then kill the process
#if [ ! -z "$PID" ]; then
#    kill $PID
#    if [ $? -eq 0 ]; then
#        echo "Successfully killed the SSH tunnel process with PID: $PID"
#    else
#        echo "Error killing process with PID: $PID"
#    fi
#else
#    echo "SSH tunnel process not found. Nothing to kill."
#fi

# Run the Ansible playbook to uninstall ingress-nginx
BASTION_IP=$(terraform output -raw bastion_public_ip)
VPC_ID=$(terraform output -raw vpc_id)
ansible-playbook uninstall_ingress_nginx.yaml -i $BASTION_IP, -u ec2-user --private-key=concourse-k8s.pem -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' -e "vpc_id=$VPC_ID"


# Check if the Ansible playbook command was successful
if [ $? -ne 0 ]; then
    echo "Error: Ansible playbook failed. Not proceeding with terraform destroy."
    exit 1
fi

terraform taint aws_instance.bastion

# Run Terraform commands, passing the password as a variable
terraform plan -out=tfplan.out -var "sudo_password=$SUDO_PASSWORD"
terraform apply "tfplan.out"

#BASTION_IP=$(terraform output -raw bastion_public_ip)
#ssh -i concourse-k8s.pem -L 8080:localhost:8080 ec2-user@$BASTION_IP -N &
