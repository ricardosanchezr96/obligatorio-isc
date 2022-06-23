# Para hacer el deploy de Online-Boutique se hara uso de un equipo Bastion.
# Para esto se creará una instancia EC2, para el obligatorio se utiliza una tipo T2.micro.
# Se le indica el tipo de AMI (Amazon Linux), la clave SSH que se utilizara.
# y la subnet de AWS donde se conectara.
resource "aws_instance" "bastion" {
  ami                    = var.ami-id
  instance_type          = var.inst-type
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  key_name               = "vockey"
 # Al momento de inicializar el Bastion, se ejecutara un script llamado "provision.sh"
 # el cual contiene la secuencia de comandos necesaria para hacer el deploy automatico
 # de Online-Boutique. 
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

# Se genera una dependencia para que el Bastion no se cree antes de que
# termine la creacion del Node Group (y del Cluster EKS).
# De esta forma nos aseguramos que, una vez operativo el Bastion,
# podra conectarse sin inconvenientes al Cluster para levantar Online-Boutque.
depends_on = [
    aws_eks_node_group.obligatorio-ng
  ]

}
