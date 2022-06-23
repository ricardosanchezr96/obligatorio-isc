# Creación de Cluster EKS, llamado "obligatorio-eks"
# Para crear el Cluster se indica un nombre para el recurso,
# el ARN del role que utilizará para su creación y las subnets
# que utilizará
resource "aws_eks_cluster" "obligatorio-eks" {
  name     = "obligatorio-eks"
# NOTA: En vista de las limitaciones que presenta trabajar con AWS Academy,
# cada participante que requiera hacer el deploy de este elemento deberá modificar 
# el ARN, ya que es un ID único por cuenta y no tenemos posibilidad de modificar
# roles ni permisos
  role_arn = "arn:aws:iam::563973949950:role/LabRole"

  vpc_config {
    subnet_ids = [aws_subnet.obligatorio-subnet-a.id, aws_subnet.obligatorio-subnet-b.id]
  }

}
