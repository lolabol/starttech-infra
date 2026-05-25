variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type = string
  default = "625272706271"
}

variable "project_name" {
  description = "Project name"
  type = string
  default = "starttech"
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "AWS key pair name for EC2"
  type = string
}

variable "mongodb_uri" {
  description = "MongoDB Atlas connection URI"
  type = string
  sensitive = true
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type = number
  default = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type = number
  default = 3
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type = number
  default = 2
}


