# Creacion de Route Table, la cual permitira al IGW brindar conectividad hacia Internet.
# Se le debe indicar un nombre, una default route table, el ID del IGW y el CIDR de las
# direcciones requeridas.

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