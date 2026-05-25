# StartTech Infrastructure

## Overview
This repository contains the Infrastructure as Code (IaC) for the StartTech application using Terraform and GitHub Actions CI/CD pipeline.

## Repository Structure
starttech-infra/
├── .github/
│   └── workflows/
│       └── infrastructure-deploy.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── networking/
│       ├── compute/
│       ├── storage/
│       └── monitoring/
├── scripts/
│   └── deploy-infrastructure.sh
├── monitoring/
│   ├── cloudwatch-dashboard.json
│   ├── alarm-definitions.json
│   └── log-insights-queries.txt
└── README.md

## Prerequisites
- AWS CLI installed and configured
- Terraform v1.5.0 or higher
- AWS account with appropriate permissions

## AWS Resources Created
- VPC with public and private subnets
- Application Load Balancer
- Auto Scaling Group with EC2 instances
- ECR repository for Docker images
- S3 bucket for frontend hosting
- CloudFront distribution
- ElastiCache Redis cluster
- CloudWatch log groups and alarms
- IAM roles and policies

## Setup

### 1. Configure AWS credentials
aws configure

### 2. Create terraform.tfvars file
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

Edit terraform.tfvars with your values:
- key_pair_name: Your AWS key pair name
- mongodb_uri: Your MongoDB Atlas connection string

### 3. Set environment variables
export TF_VAR_key_pair_name=your-key-pair-name
export TF_VAR_mongodb_uri=your-mongodb-uri

### 4. Deploy infrastructure
./scripts/deploy-infrastructure.sh

### 5. View outputs
cd terraform
terraform output

## CI/CD Pipeline
The infrastructure pipeline triggers automatically on push to main branch.

### Required GitHub Secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- KEY_PAIR_NAME
- MONGODB_URI

## Monitoring
- CloudWatch dashboard: starttech-dashboard
- Log groups: /starttech/backend and /starttech/frontend
- Alarms: CPU utilization, response time, unhealthy hosts

## Cleanup
To destroy all infrastructure:
cd terraform
terraform destroy
