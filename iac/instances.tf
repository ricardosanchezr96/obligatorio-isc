resource "aws_instance" "bastion" {
  ami                    = var.ami-id
  instance_type          = var.inst-type
  vpc_security_group_ids = [aws_security_group.obligatorio-sg.id]
  key_name               = "vockey"
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
# provisioner "remote-exec" {
#     inline = [
#       "sleep 60",
#       "cd /tmp",
#       "git clone ${each.value["src"]}",
#       "sleep 30",
#       "cd projcode-ms-${each.value["name"]}",
#       "cp /tmp/Dockerfile Dockerfile",
#       "export MS=${each.value["name"]}-service-example",
#       "if [ ${each.value["name"]} == orders ]; then export APP_ARGS='http://172.17.0.7:8080 http://172.17.0.6:8080 http://172.17.0.5:8080'; else export APP_ARGS='';fi", #To be improved
#       #"echo $APP_ARGS",
#       "sudo docker build --build-arg JAR_FILE=$MS.jar -t $MS:1 .",
#       "sleep 30",
#       "sudo docker run -d --name $MS $MS:1"
#     ]
#   }

depends_on = [
    aws_eks_node_group.obligatorio-ng
  ]

}

output "bastion_dns" {
  value = aws_instance.bastion.public_dns
}