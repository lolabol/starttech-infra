# StartTech Architecture

## Overview
StartTech uses a modern cloud-native architecture on AWS with
a React frontend, Golang backend API, MongoDB database and
Redis caching layer.

## Architecture Diagram

Internet
    |
CloudFront (CDN)
    |
S3 (Frontend - React)
    |
Application Load Balancer
    |
Auto Scaling Group
    |
EC2 Instances (Backend - Golang)
    |         |
MongoDB    ElastiCache
Atlas      (Redis)

## Components

### Frontend
- React application built with Vite
- Hosted on S3 as static website
- Served globally via CloudFront CDN
- Environment specific configurations

### Backend
- Golang REST API
- Runs on EC2 instances behind ALB
- Auto scales based on CPU utilization
- Docker containerized via ECR
- Health check endpoint at /health

### Database
- MongoDB Atlas for data persistence
- Managed cloud database service
- Secure connection via connection string

### Caching
- ElastiCache Redis cluster
- Session management
- Application caching layer

### Networking
- VPC with public and private subnets
- Internet Gateway for public access
- Security groups for each component
- ALB for load distribution

### Security
- IAM roles with least privilege access
- Security groups restricting traffic
- Secrets managed via GitHub Secrets
- Docker image scanning via Trivy
- Dependency scanning via npm audit

### Monitoring
- CloudWatch log groups for all services
- CloudWatch alarms for CPU and response time
- CloudWatch dashboard for visualization
- Log Insights for query analysis

## CI/CD Flow

### Frontend Pipeline
1. Code pushed to feature/full-stack branch
2. GitHub Actions triggered
3. Node.js dependencies installed
4. Security scan with npm audit
5. React app built
6. Files synced to S3
7. CloudFront cache invalidated

### Backend Pipeline
1. Code pushed to feature/full-stack branch
2. GitHub Actions triggered
3. Go tests run
4. Docker image built
5. Image scanned with Trivy
6. Image pushed to ECR
7. ASG rolling update triggered
8. Smoke test on ALB health endpoint

### Infrastructure Pipeline
1. Code pushed to main branch
2. GitHub Actions triggered
3. Terraform initialized
4. Terraform plan generated
5. Terraform apply executed
