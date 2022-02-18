provider "aws" {
  profile = "terraform"
  region = "us-east-2"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {

}

module "eks-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.5"

  name = "app-eks-cluster"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kurbenetes.io/cluster/app-eks-cluster" = "shared"
  }

  public_subnet_tags ={
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1 
  }
  
  private_subnet_tags ={
    "kubernetes.io/cluster/app-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}
