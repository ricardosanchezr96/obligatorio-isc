# Se crea Security Group, el cual será asociado a la instancia

resource "aws_security_group" "obligatorio-sg" {
  name        = "obligatorio-sg"
  description = "Permitir acceso via SSH"
  vpc_id      = aws_vpc.obligatorio-vpc.id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "obligatorio-sg"
  }
}

