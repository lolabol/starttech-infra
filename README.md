# StartTech Infrastructure

## Overview
This repository contains the Infrastructure as Code (IaC) for the StartTech 
full-stack application. It provisions all AWS resources using Terraform and 
automates deployments via GitHub Actions CI/CD pipeline.

## Architecture
- **Region: us-east-1
- **Frontend**: React app hosted on S3, served via CloudFlare Pages
- **Backend**: Golang API running on EC2 instances behind an ALB
- **Cache**: ElastiCache Redis cluster for sessions and caching
- **Database**: MongoDB Atlas (cloud-hosted)
- **Logging**: CloudWatch for infrastructure and application logs
- **Container Registry**: AWS ECR for Docker images

## CDN Solution: CloudFlare pages (Instead of AWS CloudFront)
AWS CloudFront was originally the planned CDN solution as specified in the assessment. However, my AWS account was restricted from using CloudFront. At first I raised a support ticket with AWS requesting CloudFront access and waited for days with no response from AWS support. I followed up and attempted live chat support to expedite the request. All my attempts were unsuccessful.

![](https://github.com/lolabol/starttech-infra/blob/main/evidence/CloudFlare.jpg?raw=true)

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
- MongoDB Atlas cluster (free tier works)

## AWS Resources Created
- VPC with public and private subnets across 2 AZs
- Application Load Balancer with health checks
- Auto Scaling Group (min: 1, max: 3, desired: 2)
- EC2 instances (t2.micro) with Docker
- ECR repository for backend Docker images
- S3 bucket for frontend static hosting
- ElastiCache Redis cluster (cache.t3.micro)
- CloudWatch log groups (/starttech/backend)
- IAM roles and policies for EC2

## Setup & Deployment

### Option 1 — Automated via CI/CD (Recommended)

#### 1. Fork this repository

#### 2. Add GitHub Secrets
Go to your repo → Settings → Secrets and variables → Actions and add:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key |
| `KEY_PAIR_NAME` | Your EC2 key pair name |
| `MONGODB_URI` | Your MongoDB Atlas connection string |
| `JWT_SECRET_KEY` | Secret key for JWT token signing |

#### 3. Trigger the Pipeline
- **Push to main** → automatically runs `terraform apply`
- **Open a Pull Request** → automatically runs `terraform plan` 
  and posts the output as a PR comment for review

### Option 2 — Manual Deployment

#### 1. Configure AWS credentials
```bash
aws configure
```

#### 2. Create terraform.tfvars file
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Edit `terraform.tfvars` with your values:
```hcl
key_pair_name = "your-key-pair-name"
mongodb_uri   = "mongodb+srv://..."
jwt_secret_key = "your-secret-key"
```

#### 3. Deploy infrastructure
```bash
./scripts/deploy-infrastructure.sh
```

#### 4. View outputs
```bash
cd terraform
terraform output
```

## Accessing the Application

| Service | URL |
|---------|-----|
| Frontend | https://starttech-frontend.pages.dev |
| Backend API | http://starttech-alb-1520060583.us-east-1.elb.amazonaws.com |
| Health Check | http://starttech-alb-1520060583.us-east-1.elb.amazonaws.com/health |

## CI/CD Pipeline

### Infrastructure Pipeline (this repo)
- **Pull Request** → runs `terraform plan`, posts output as PR comment
- **Merge to main** → runs `terraform apply` automatically

### Application Pipeline (starttech-application repo)
- **Push to main** → builds Docker image, pushes to ECR, deploys to EC2

## Monitoring & Observability
- **CloudWatch Log Groups**: `/starttech/backend`
  - `{instance_id}/user-data` — EC2 startup logs
  - `{instance_id}/docker` — Application container logs
- **ALB Health Checks**: `/health` endpoint on port 8080
- **Auto Scaling**: Scales between 1-3 instances based on load

## Security
- EC2 instances only accept traffic from ALB security group
- Redis only accepts traffic from EC2 security group
- All secrets stored in GitHub Actions secrets — never hardcoded
- IAM roles follow least-privilege principle
- MongoDB credentials managed via environment variables

## Cleanup
To destroy all infrastructure and avoid AWS charges:
```bash
cd terraform
terraform destroy
```

> ⚠️ This will permanently delete all resources including EC2 instances,
> ALB, Redis cluster, and S3 bucket contents.
