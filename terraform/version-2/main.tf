terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"
  name    = var.vpc_name
  cidr    = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  intra_subnets   = var.vpc_intra_subnets

  enable_dns_hostnames = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []


  tags = {
    "Name" = "Demo VPC"
  }

}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.1.0"

  engine               = "postgres"
  engine_version       = "12.5"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.t2.micro"
  db_subnet_group_name = aws_db_subnet_group.default.name
  identifier           = "my-demo-rds"

  allocated_storage = 20

  name     = "mypostgres"
  username = "demo_postgresql"
  password = "saac02!rds"

  port = 5432

  publicly_accessible     = false
  backup_retention_period = 0
  deletion_protection     = false
  multi_az                = false

  subnet_ids = module.vpc.intra_subnets

  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = module.vpc.intra_subnets

  tags = {
    Name = "Demo DB"
  }
}
