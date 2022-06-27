# Se crea el Security Group, el cual sera asociado al Bastion
# para poder acceder via SSH.

resource "aws_default_security_group" "obligatorio-sg" {
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

