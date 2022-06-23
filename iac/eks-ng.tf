# Se crea el Node Group donde se levantarán los Workers de EKS
# Para la creación de este recurso se indica el Cluster donde 
# trabajará, se le asigna un nombre y el ARN del Role a utilizar
# A su vez se le indica las subnets en las que se hará el deploy.
# Estas subnets están en diferentes AZ, logrando así redundancia del servicio
resource "aws_eks_node_group" "obligatorio-ng" {
  cluster_name    = aws_eks_cluster.obligatorio-eks.name
  node_group_name = "obligatorio-ng"
# NOTA: En vista de las limitaciones que presenta trabajar con AWS Academy,
# cada participante que requiera hacer el deploy de este elemento deberá modificar 
# el ARN, ya que es un ID único por cuenta y no tenemos posibilidad de modificar
# roles ni permisos
  node_role_arn   = "arn:aws:iam::563973949950:role/LabRole"
  subnet_ids      = [aws_subnet.obligatorio-subnet-a.id, aws_subnet.obligatorio-subnet-b.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

}