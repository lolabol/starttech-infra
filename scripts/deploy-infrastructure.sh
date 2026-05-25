#!/bin/bash
echo "Deploying infrastructure with Terraform..."

# Variables
AWS_REGION="us-east-1"
TF_DIR="../terraform"

# Check required environment variables
if [ -z "$TF_VAR_key_pair_name" ] || [ -z "$TF_VAR_mongodb_uri" ]; then
  echo "Error: Required environment variables not set!"
  echo "Please set:"
  echo "  export TF_VAR_key_pair_name=<your-key-pair-name>"
  echo "  export TF_VAR_mongodb_uri=<your-mongodb-uri>"
  exit 1
fi

# Initialize Terraform
echo "Initializing Terraform..."
cd $TF_DIR
terraform init

# Validate configuration
echo "Validating Terraform configuration..."
terraform validate

# Plan deployment
echo "Planning infrastructure deployment..."
terraform plan

# Apply deployment
echo "Applying infrastructure..."
terraform apply -auto-approve

echo "Infrastructure deployed successfully!"
echo "Run 'terraform output' to see deployment details."
