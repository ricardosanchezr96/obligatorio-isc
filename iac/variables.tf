# Archivo de variables para simplificar la portabilidad de la infraestructura
# que a su vez permite que realizar modificaciones en la misma sea mucho mas directo

# Perfil de conexion contra AWS
variable "perfil" {
  default = "default"
}
# Region de AWS donde se trabajara
variable "region" {
  default = "us-east-1"
}
# Tipo de instancia a utilizar para el bastion
variable "inst-type" {
  default = "t2.micro"
}
# ID de la AMI que se utilizara para aprovisionar el bastion
variable "ami-id" {
  default = "ami-03ededff12e34e59e"
}
# Red que se utilizara para el VPC
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
# Porcion de red del VPC para la subnet a
variable "subnet-a" {
  default = "172.16.1.0/24"
}
# Porcion de red del VPC para la subnet b
variable "subnet-b" {
  default = "172.16.2.0/24"
}
# Zonas de disponibilidad a utilizar
variable "vpc_aws_az-a" {
  default = "us-east-1a"
}

variable "vpc_aws_az-b" {
  default = "us-east-1b"
}
# IP publica del bastin a modo de variable output, para facilitar 
# la conexion via ssh al mismo
output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}