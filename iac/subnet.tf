# Creacion de subnets en diferentes AZ, para tener redundancia en los servicios
# Se le indica el VPC, las redes que manejaran y se habilita la creacion automatica 
# de una IP publica para los recursos que se conecten a ellas

resource "aws_subnet" "obligatorio-subnet-a" {
  vpc_id      = aws_vpc.obligatorio-vpc.id
  cidr_block = var.subnet-a
  availability_zone =  var.vpc_aws_az-a
  map_public_ip_on_launch = true
  tags = {
    Name = "obligatorio-subnet-a"
  }
}

resource "aws_subnet" "obligatorio-subnet-b" {
  vpc_id      = aws_vpc.obligatorio-vpc.id
  cidr_block = var.subnet-b
  availability_zone =  var.vpc_aws_az-b
  map_public_ip_on_launch = true
  tags = {
    Name = "obligatorio-subnet-b"
  }
}