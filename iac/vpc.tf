# Creación de VPC

resource "aws_vpc" "obligatorio-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "obligatorio-vpc"
  }
}