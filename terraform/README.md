# Rails Monitoring Infrastructure

This directory contains Terraform configuration to deploy a Rails monitoring application on AWS.

## Infrastructure Components

- VPC with public subnet
- Internet Gateway
- Security Group with ports for SSH, HTTP, HTTPS, Rails (3000), Grafana (3001), and Prometheus (9090)
- EC2 instance (Ubuntu 22.04 LTS) with Docker installed
- Elastic IP for static public IP address

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed
3. S3 bucket named `kenny-rails-terraform` already created in eu-west-2 region

## Usage

1. Initialize Terraform with the S3 backend:

```bash
terraform init
```

2. Create a `terraform.tfvars` file with your SSH key name and optionally override defaults:

```
key_name = "your-ssh-key-name"

# Optional overrides
# instance_type = "t2.large"  # Default is t2.medium
# ami_id = "ami-0505148b3591e4c07"  # Default is Ubuntu 22.04 LTS in eu-west-2
```

3. Plan the deployment:

```bash
terraform plan
```

4. Apply the configuration:

```bash
terraform apply
```

5. Connect to the EC2 instance using the Elastic IP:

```bash
ssh -i /path/to/your-key.pem ubuntu@$(terraform output -raw elastic_ip)
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```