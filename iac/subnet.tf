# Creación de subnet

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