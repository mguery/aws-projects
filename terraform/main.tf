terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC resource 
resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.main_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "Demo VPC"
  }
}

# Public subnets 
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnets[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "Public subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnets[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "Public subnet 2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnets[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "Public subnet 3"
  }
}

# Public route table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    "Name" = "Public Route Table"
  }

}

# Public route table association 
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}


# Private subnets 
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.private_subnets[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "Private subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.private_subnets[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "Private subnet 2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.private_subnets[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "Private subnet 3"
  }
}

# Private route table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo_ngw.id
  }

  tags = {
    "Name" = "Private Route Table"
  }

}

# Private route table association 
resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}


# Internet gateway  
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    "Name" = "Main Internet Gateway"
  }
}


# NAT gateway
resource "aws_nat_gateway" "demo_ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  depends_on = [aws_internet_gateway.demo_igw]

  tags = {
    "Name" = "Main NAT Gateway"
  }
}


# Security group 
resource "aws_security_group" "web_access" {
  name        = "allow_web"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = {
    Name = "demo vpc sg"
  }
}


# Elastic IP  
resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.ec2.id
}


# EC2 instance  
resource "aws_instance" "ec2" {
  ami               = "ami-0d5eff06f840b45e9"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"
  key_name          = "mydemokeypair"

  tags = {
    "Name" = "Instance for Demo VPC"
  }

}

output "eip" {
  value = aws_eip.eip.public_ip
}

