# Kubernetes Project: Concourse Deployment

## Overview
This project automates the deployment of Concourse on a Kubernetes cluster within AWS. Through the combined power of Terraform for infrastructure provisioning and Ansible for configuration management, we've condensed and optimized the deployment process. The automation ensures that users experience a reliable and efficient setup. After deployment, Concourse can be accessed via a web interface through the Class Load Balancer, providing a straightforward portal for CI/CD management. Additionally, the integration of ingress-nginx allows for seamless web browser access, making the entire platform both robust and user-friendly.

## Prerequisites
- AWS Account
- Terraform installed
- Ansible installed
- Access to AWS S3 bucket for Terraform state management

## Setup Instructions
### 1. Infrastructure Setup
- #### Modify Bucket Names
Edit the bucket names specified in main.tf and variables.tf to fit your desired AWS environment.

- #### Initialize Terraform:
Navigate to the project's root directory and run:
`terraform init`

- #### Apply Terraform Configuration
Deploy the AWS resources:
`./apply_infrastructure.sh`

- #### Retrieve Bastion Host IP
Once Terraform has finished provisioning the resources, get the public IP of the bastion instance:
`terraform output bastion_public_ip`

- #### Accessing Key Pair
Terraform script will create a key pair and save the private key as `concourse-k8s.pem` in the current directory. Ensure you keep this key secure.

### 2. Accessing Concourse Web
Access to the Concourse web interface is facilitated through the Class Load Balancer. Its URL is printed by the Ansible Notebook executed by the `terraform apply` command.

**Credentials**:

-   **Username**: `test`
-   **Password**: `test`

### 3. Destroy infrastructure
Destroy the AWS resources:
`./destroy_infrastructure.sh`

  ## Conclusion
Successfully deploying Concourse on Kubernetes offers a robust CI/CD platform that's scalable and efficient. By leveraging AWS resources through Terraform and managing configurations with Ansible, you can achieve a seamless setup process. The ingress-nginx provides easy web access, making the entire system user-friendly. It's crucial to ensure security by safeguarding generated key pairs and credentials. When the setup is no longer required, the infrastructure can be quickly torn down using the provided scripts. This guide serves as a comprehensive resource for initializing, accessing, and de-provisioning the Concourse deployment on Kubernetes within AWS.
