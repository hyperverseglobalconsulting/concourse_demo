#!/bin/bash

# Script name: destroy_infrastructure.sh

# Retrieve AWS credentials from aws configure
#AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
#AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Run the Ansible playbook to uninstall ingress-nginx
BASTION_IP=$(terraform output -raw bastion_public_ip)
VPC_ID=$(terraform output -raw vpc_id)
ansible-playbook uninstall_ingress_nginx.yaml -i $BASTION_IP, -u ec2-user --private-key=django-k8s.pem -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' -e "vpc_id=$VPC_ID"


# Check if the Ansible playbook command was successful
if [ $? -ne 0 ]; then
    echo "Error: Ansible playbook failed. Not proceeding with terraform destroy."
    exit 1
fi

terraform taint aws_instance.bastion

# Ask for the sudo password
read -s -p "Enter the sudo password: " SUDO_PASSWORD
echo

# Run Terraform commands, passing the password as a variable
terraform plan -out=tfplan.out -var "sudo_password=$SUDO_PASSWORD"
terraform apply "tfplan.out"

