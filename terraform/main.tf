terraform {
  backend "s3" {
    bucket = "starttech-terraform-state-625272706271"
    key = "terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}

module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  mongodb_uri       = var.mongodb_uri
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
  alb_sg_id         = module.networking.alb_sg_id
}

module "monitoring" {
  source       = "./modules/monitoring"
  project_name = var.project_name
  environment  = var.environment
}
