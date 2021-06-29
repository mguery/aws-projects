variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "main_vpc"
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "AZs for VPC"
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "vpc_intra_subnets" {
  description = "Intra subnets for VPC"
  type    = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}
