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
mkdir .aws
touch $AWS_CREDENTIALS_FILE
chown ec2-user:ec2-user $AWS_CREDENTIALS_FILE
chmod 600 $AWS_CREDENTIALS_FILE

echo "[default]"                              > $AWS_CREDENTIALS_FILE
echo "aws_access_key_id= ASIAYGT3XRH7HG4LYREL"        >> $AWS_CREDENTIALS_FILE
echo "aws_secret_access_key= vYsXe7Y3/Qd1ruiDkc7/qhu+h0dRTZNKTzU3fPpP" >> $AWS_CREDENTIALS_FILE
echo "aws_session_token= FwoGZXIvYXdzEDAaDM58SCeHNPqWkHMjWCK4AQjR1R3ZEJNq/nssfrXq5Zz2+/RtF2Stgz5qNz4fH0wkcnu8Owbcj3X/LvW/yD5O8sQRCSOXvk1hhBUHckCKX6Wk+3jepqo7eAR/dCbR8zGLqkeRZ8RHHoOtaUBXjoe4FAB2oLuJSKLklHbQewgr1Hg979EMMUYyrJYBRLIHZKPwMa4t66uvY/kQ4+yRFGDX7MfjLqiO56b5/XvxbZkHcRhwog8pyKrnxJwpgt3Yxidc67e/HKA2c5gowu7DlQYyLVHB68f4Y537bBGB7Wwrt12fBU/04e2YZULahiotMFwu/vADwJP30njYzsIoiQ==" >> $AWS_CREDENTIALS_FILE


touch $AWS_CONFIG_FILE
chown ec2-user:ec2-user $AWS_CONFIG_FILE
chmod 600 $AWS_CONFIG_FILE
echo "[default]"                              > $AWS_CONFIG_FILE
echo "region = us-east-1" >> $AWS_CONFIG_FILE
echo "output = yaml" >> $AWS_CONFIG_FILE

su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obligatorio-eks"


