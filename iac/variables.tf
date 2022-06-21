variable "perfil" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

variable "inst-type" {
  default = "t2.micro"
}

variable "ami-id" {
  default = "ami-03ededff12e34e59e"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet-a" {
  default = "172.16.1.0/24"
}

variable "subnet-b" {
  default = "172.16.2.0/24"
}

variable "vpc_aws_az-a" {
  default = "us-east-1a"
}

variable "vpc_aws_az-b" {
  default = "us-east-1b"
}
# output "ec2-id-1" {
#   value = aws_instance.ac1-instance.0.id
# }

# output "ec2-id-2" {
#   value = aws_instance.ac1-instance.1.id
# }

# output "ec2-dns-1" {
#   value = aws_instance.ac1-instance.0.public_dns
# }

# output "ec2-dns-2" {
#   value = aws_instance.ac1-instance.1.public_dns
# }

# output "ec2-public-ip-1" {
#   value = aws_instance.ac1-instance.0.public_ip
# }

output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

# output "lb-ip" {
#   value = aws_lb.ac1-lb.dns_name
# }