# Creación de Internet Gateway, el cual permitirá la salida a Internet
# Desde las instancias que se creen dentro del VPC obligatorio-vpc
# Se le asigna un nombre y se enlaza al VPC correspondiente

resource "aws_internet_gateway" "obligatorio-igw" {
  vpc_id = aws_vpc.obligatorio-vpc.id

  tags = {
    Name = "obligatorio-igw"
  }
}