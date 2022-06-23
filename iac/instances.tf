# Para hacer el deploy de Online-Boutique se hará uso de un equipo bastión
# Para esto se creará una instancia EC2 tipo T2.micro
# Se le indica el tipo de AMI (Amazon Linux), la clave SSH que se utilizará
# y la subnet de AWS donde se conectará
resource "aws_instance" "bastion" {
  ami                    = var.ami-id
  instance_type          = var.inst-type
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  key_name               = "vockey"
 # Al momento de inicializar el bastión, se ejecutará un Script llamado provision.sh
 # el cual contiene la secuencia de comandos necesaria para hacer el deploy automático
 # de Online-Boutique 
  user_data = file("./provision.sh")
  subnet_id = aws_subnet.obligatorio-subnet-a.id
  tags = {
    Name      = "bastion"
    terraform = "True"

  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./vockey.pem")
    host        = self.public_ip
  }

# Se crea una dependencia para que el bastión no se cree antes de que
# Termine la creación del Node Group (y del Cluster EKS)
# De esta forma nos aseguramos que, una vez operativo, podrá conectarse sin
# inconvenientes al Cluster para levantar la página web
depends_on = [
    aws_eks_node_group.obligatorio-ng
  ]

}
