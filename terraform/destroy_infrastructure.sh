#!/bin/bash

# Script name: destroy_infrastructure.sh

# Run the Ansible playbook to uninstall ingress-nginx
BASTION_HOST=$(terraform output -raw bastion_public_ip)
VPC_ID=$(terraform output -raw vpc_id)
ansible-playbook -vvv -i "$BASTION_HOST," uninstall_ingress_nginx.yaml -u ec2-user --private-key=django-k8s.pem -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' -e "vpc_id=$VPC_ID"


# Check if the Ansible playbook command was successful
if [ $? -ne 0 ]; then
    echo "Error: Ansible playbook failed. Not proceeding with terraform destroy."
    exit 1
fi

# Now, run terraform destroy if the Ansible playbook command was successful
terraform destroy -auto-approve

