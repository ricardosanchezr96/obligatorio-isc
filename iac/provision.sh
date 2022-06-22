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
echo "aws_access_key_id= ASIAYGT3XRH7LICXAPII"        >> $AWS_CREDENTIALS_FILE
echo "aws_secret_access_key= TVsbBj4LID8Jpfdt0NFrlU9902v+IjygHQ5yO9s5" >> $AWS_CREDENTIALS_FILE
echo "aws_session_token= FwoGZXIvYXdzEF0aDDGEVMVGL5eMcdJ9qSK4AeWVh8IaU9hDU5Mp6ZQHSsiLf6I7ufXXy6yFUqztUcP1VvTXNOEhJGH0ZS+kBe5lrTaz4FrMO5Au70A1O1scmPdncD8Zv0UjZ8oZuXREnyLx7yuH+aSDHkqrk9nMNo+f8nSg5ySGy1+oZuCdMby8jEex4LdocrcxrXNw3v7wKnwcCIvb2loACR4g6bI0+bibgDrxNeF24Me600n3gOy0BZZ64X4RzCF/oc2c5P7hEX669M1in6UA8RQo7eDNlQYyLSdeBnoQQlEi5Gfk7o65w7N86rOO0C2Exr3JrgZ3ifUU0SYiDNC26mfI/UCwyQ==" >> $AWS_CREDENTIALS_FILE


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

