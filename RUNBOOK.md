# StartTech Operations Runbook

## Overview
This runbook provides operational procedures for managing
the StartTech application infrastructure.

## Common Operations

### Check Application Health
curl http://<alb-dns-name>/health

### Check Pod/Instance Status
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names starttech-asg

### View Application Logs
aws logs tail /starttech/backend --follow

### View Frontend Logs
aws logs tail /starttech/frontend --follow

## Deployment Procedures

### Deploy Frontend
./scripts/deploy-frontend.sh <s3-bucket-name> <cloudfront-id>

### Deploy Backend
./scripts/deploy-backend.sh <ecr-repository-url>

### Deploy Infrastructure
./scripts/deploy-infrastructure.sh

## Rollback Procedures

### Rollback Backend
./scripts/rollback.sh <ecr-repository-url> <previous-image-tag>

### Rollback Frontend
aws s3 sync s3://<backup-bucket> s3://<frontend-bucket> --delete
aws cloudfront create-invalidation \
  --distribution-id <cloudfront-id> \
  --paths "/*"

### Rollback Infrastructure
cd terraform
terraform plan -target=<resource>
terraform apply -target=<resource>

## Troubleshooting

### Application Not Responding
1. Check ALB health checks:
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn>

2. Check EC2 instances:
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names starttech-asg

3. Check application logs:
aws logs tail /starttech/backend --follow

### High CPU Usage
1. Check CloudWatch metrics:
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --period 300 \
  --statistics Average \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S)

2. Manually scale up if needed:
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name starttech-asg \
  --desired-capacity 3

### Database Connection Issues
1. Check MongoDB Atlas status at cloud.mongodb.com
2. Verify MONGODB_URI environment variable is correct
3. Check security group allows outbound traffic

### Redis Connection Issues
1. Check ElastiCache cluster status:
aws elasticache describe-cache-clusters \
  --cache-cluster-id starttech-redis

2. Verify security group allows port 6379
3. Check Redis endpoint in application config

## Monitoring

### View CloudWatch Dashboard
1. Go to AWS Console
2. Navigate to CloudWatch
3. Click Dashboards
4. Select starttech-dashboard

### View Alarms
aws cloudwatch describe-alarms \
  --alarm-names starttech-high-cpu starttech-low-cpu

### Run Log Insights Query
1. Go to AWS Console
2. Navigate to CloudWatch
3. Click Log Insights
4. Select /starttech/backend log group
5. Use queries from monitoring/log-insights-queries.txt
