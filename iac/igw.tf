# Creación de Internet Gateway

resource "aws_internet_gateway" "obligatorio-igw" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  tags = {
    Name = "obligatorio-igw"
  }
}