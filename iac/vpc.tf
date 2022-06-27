# Creacion de VPC, desde donde se controlara el resto de la infraestructura.
# Se indica un nombre y la red que manejara.

resource "aws_vpc" "obligatorio-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  
  tags = {
    Name = "obligatorio-vpc"
  }
}