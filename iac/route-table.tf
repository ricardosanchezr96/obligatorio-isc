# Creación de Route Table

resource "aws_default_route_table" "obligatorio-rt" {
  default_route_table_id = aws_vpc.obligatorio-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obligatorio-igw.id
  }

  tags = {
    Name = "obligatorio-rt"
  }
}