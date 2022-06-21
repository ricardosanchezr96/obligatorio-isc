resource "aws_eks_node_group" "obligatorio-ng" {
  cluster_name    = aws_eks_cluster.obligatorio-eks.name
  node_group_name = "obligatorio-ng"
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

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
}