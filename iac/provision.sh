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


cd /home/ec2-user
git clone https://github.com/ricardosanchezr96/obligatorio-isc.git
mkdir .aws
touch $AWS_CREDENTIALS_FILE
chown ec2-user:ec2-user $AWS_CREDENTIALS_FILE
chmod 600 $AWS_CREDENTIALS_FILE

echo "[default]"                              > $AWS_CREDENTIALS_FILE
echo "aws_access_key_id= ASIAYGT3XRH7OHR35RWS"        >> $AWS_CREDENTIALS_FILE
echo "aws_secret_access_key= IZBF0j+XqqITqVV2Axbmm8bJDowT6GfXEFu+Cjbp" >> $AWS_CREDENTIALS_FILE
echo "aws_session_token= FwoGZXIvYXdzEGIaDGwrWceoG1BtctVYAyK4AS8l0lpScaaJ8omT7NKvr/YWTD3ISLxwU0cUPefMxA/VjEsQIHVkRl84rgaSK6FT5mZwKXezCIRUjytq1Me5n2crXJQAb8YSIy+0hepR4z72lbs2CZMKUOjOgTBVu1b+1nfaR3mZKPreiw7IlDtRk5bh6xK2cPxPUiRBkmrkrIsfLBRrwEw/oAnZejkZRMMQmtyW2i6T9iYAZoO0OLF7uoz36Kjdm0Xm9P7z1xJ4IoT8RU21F947HOEopd/OlQYyLdV+/SjmetHQVMuwBWCsy9guLn2I/kvKVLzRRgRyUgOcSTYFrlc1oxXjHbbPMQ==" >> $AWS_CREDENTIALS_FILE


touch $AWS_CONFIG_FILE
chown ec2-user:ec2-user $AWS_CONFIG_FILE
chmod 600 $AWS_CONFIG_FILE
echo "[default]"                              > $AWS_CONFIG_FILE
echo "region = us-east-1" >> $AWS_CONFIG_FILE
echo "output = yaml" >> $AWS_CONFIG_FILE

su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obligatorio-eks"



cd obligatorio-isc/src/

su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/adservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/cartservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/checkoutservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/currencyservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/frontend/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/paymentservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/productcatalogservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/recommendationservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/redis/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/shippingservice/deployment/kubernetes-manifests.yaml"


#Comando para obtener endpoint del ELB dedse bastion
#kubectl get -o json svc frontend-external | grep hostname
