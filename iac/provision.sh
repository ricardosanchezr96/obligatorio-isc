#!/bin/bash

AWS_CREDENTIALS_FILE="/home/ec2-user/.aws/credentials"
AWS_CONFIG_FILE="/home/ec2-user/.aws/config"

yum update -y # Update the installed packages and package cache on the instance
yum install git -y # Install most recent git package
amazon-linux-extras install docker # Install the most recent Docker Engine package
systemctl enable docker # Ensure that the Docker daemon starts after each system reboot
service docker start # Start docker service
usermod -a -G docker ec2-user # Add the ec2-user to the docker group so you can execute Docker commands without using sudo


curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl # Download K8s installer
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl # Install kubectl

git clone https://github.com/ricardosanchezr96/obligatorio-isc.git

cd /home/ec2-user
mkdir .aws
touch $AWS_CREDENTIALS_FILE
chown ec2-user:ec2-user $AWS_CREDENTIALS_FILE
chmod 600 $AWS_CREDENTIALS_FILE

echo "[default]"                              > $AWS_CREDENTIALS_FILE
echo "aws_access_key_id= ASIAYGT3XRH7EVRNWLHI"        >> $AWS_CREDENTIALS_FILE
echo "aws_secret_access_key= qehPYiDp2QQMjWutyZpDAGaYseTRzx+JoIZwMa1U" >> $AWS_CREDENTIALS_FILE
echo "aws_session_token= FwoGZXIvYXdzEEUaDFWn1iNBBWI1a4RM6SK4AR1Uicx8WqBBvkscXS07UCou/anf3+bQBI0Jud9lTOF8ObiSMy0z4CkKaWgVlz/w/CyLQL/OZCmsGU+VS3nA/MgcH5pu5R4DLui58CPTLtBzLrMvKkuul0ZF6h5nQoGiwnSsThqS0J2IFTMqDl1ufCsAtK2Vf8Fk1ce1D43xe4UvWwZb56ie7JoWl/iV0G6/S1tu+zoEOFZmN7WPpwdQEqR4qMY5j2O8ERtEv6soWw21aLKYUqQFRekonsXIlQYyLfShdqwyOKSsonViI5OSi7xQ5x3yXxvvxD9vBZEctV5jEr/m+HY+YwnlKRYEDQ==" >> $AWS_CREDENTIALS_FILE


touch $AWS_CONFIG_FILE
chown ec2-user:ec2-user $AWS_CONFIG_FILE
chmod 600 $AWS_CONFIG_FILE
echo "[default]"                              > $AWS_CONFIG_FILE
echo "region = us-east-1" >> $AWS_CONFIG_FILE
echo "output = yaml" >> $AWS_CONFIG_FILE

su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obligatorio-eks"


cd obligatorio-isc/src/
kubectl create -f adservice/deployment/kubernetes-manifests.yaml
kubectl create -f cartservice/deployment/kubernetes-manifests.yaml
kubectl create -f checkoutservice/deployment/kubernetes-manifests.yaml
kubectl create -f currencyservice/deployment/kubernetes-manifests.yaml
kubectl create -f frontend/deployment/kubernetes-manifests.yaml
kubectl create -f paymentservice/deployment/kubernetes-manifests.yaml
kubectl create -f productcatalogservice/deployment/kubernetes-manifests.yaml
kubectl create -f recommendationservice/deployment/kubernetes-manifests.yaml
kubectl create -f redis/deployment/kubernetes-manifests.yaml
kubectl create -f shippingservice/deployment/kubernetes-manifests.yaml

