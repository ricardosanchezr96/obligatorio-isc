resource "aws_eks_cluster" "obligatorio-eks" {
  name     = "obligatorio-eks"
  role_arn = "arn:aws:iam::563973949950:role/LabRole"

  vpc_config {
    subnet_ids = [aws_subnet.obligatorio-subnet-a.id, aws_subnet.obligatorio-subnet-b.id]
  }

}

# output "endpoint" {
#   value = aws_eks_cluster.obligatorio-eks.endpoint
# }
