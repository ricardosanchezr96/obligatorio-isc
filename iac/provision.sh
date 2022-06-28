#!/bin/bash
# Script que permite aprovisionar el Bastion para hacer el deploy automatico de
# Online Boutique.

# En primer lugar se crean dos variables, las cuales corresponden al path
# absoluto de los archivos de AWS (config y credentials), para luego poder
# popularlos con las claves de cada usuario y hacer que las ejecuciones 
# sean exitosas.
AWS_CREDENTIALS_FILE="/home/ec2-user/.aws/credentials"
AWS_CONFIG_FILE="/home/ec2-user/.aws/config"

# Instalacion de dependencias varias para que el bastion pueda cumplir su funcion.
# Primero se actualiza el Sistema Operativo para tener todos los paquetes al dia.
yum update -y 
# Instalacion de Git, para luego clonar el repositorio y tener los archivos
# necesarios para el deploy.
yum install git -y 
# Instalacion de Docker Engine.
amazon-linux-extras install docker 
# Se inicia el servicio docker y se indica que inicie al levantar la instancia.
systemctl enable docker
service docker start 
# Se agrega el usuario "ec2-user" (el que utilizamos en el Bastion) al grupo docker
# para que pueda ejecutar Docker.
usermod -a -G docker ec2-user 

# Descarga e instalacion de kubectl en su version 1.22.1
curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Se posiciona en el home de ec2-user para hacer diversas tareas:
# Primero se clona el repositorio.
cd /home/ec2-user
git clone https://github.com/ricardosanchezr96/obligatorio-isc.git
# Se crea el directorio ".aws" (no se instala AWS Cli porque viene por defecto en instancias EC2).
# Luego, se crea el archivo de credenciales. En vista de que el script es ejecutado como root
# se hace un chown para que pertenezca a ec2-user, y se le cambian los permisos para que pueda
# leer y escribir en el mismo
mkdir .aws
touch $AWS_CREDENTIALS_FILE
chown ec2-user:ec2-user $AWS_CREDENTIALS_FILE
chmod 600 $AWS_CREDENTIALS_FILE

# Se popula el archivo de credenciales.
# NOTA: En esta etapa, cada participante debe modificar el contenido del archivo
# con sus propias credenciales. De lo contrario la ejecucion va a fallar.

# POR MOTIVOS DE SEGURIDAD LAS CREDENCIALES DEBEN SER ELIMINADAS DEL ARCHIVO ANTES
# DE HACER PUSH DE LOS CAMBIOS AL REPOSITORIO DE GITHUB.

echo "[default]"                              > $AWS_CREDENTIALS_FILE
echo "aws_access_key_id= "        >> $AWS_CREDENTIALS_FILE
echo "aws_secret_access_key= " >> $AWS_CREDENTIALS_FILE
echo "aws_session_token= " >> $AWS_CREDENTIALS_FILE


# Para el archivo "config" se realiza el mismo procedimiento que con "credentials".
# En este caso no es necesario eliminar la informacion ni hacer cambios, ya que
# son configuraciones de uso compartido entre los integrantes. A su vez, tampoco
# representa ninguna falla de seguridad, ya que este archivo no maneja credenciales.
touch $AWS_CONFIG_FILE
chown ec2-user:ec2-user $AWS_CONFIG_FILE
chmod 600 $AWS_CONFIG_FILE
echo "[default]"                              > $AWS_CONFIG_FILE
echo "region = us-east-1" >> $AWS_CONFIG_FILE
echo "output = yaml" >> $AWS_CONFIG_FILE

# Se realiza la conexion de kubectl al contexto del Cluster EKS creado previamente.
# A partir de este punto, para ejecutar todos los comandos se debe hacer uso de
# un mecanismo que permita a root ejecutarlos como ec2-user (su - ec2-user -c "comando").
su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obligatorio-eks"

# Se posiciona sobre el directorio "src" del repositorio recientemente clonado
# para poder hacer el deploy de los microservicios.
cd obligatorio-isc/src/

# Para finalizar, se crean, uno a uno, los deployments y servicios de Kubernetes, dejando asi
# la pagina Online-Boutique operativa.
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/adservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/cartservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/checkoutservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/currencyservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/emailservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/frontend/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/loadgenerator/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/paymentservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/productcatalogservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/recommendationservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/redis/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "kubectl create -f /home/ec2-user/obligatorio-isc/src/shippingservice/deployment/kubernetes-manifests.yaml"

### NOTA: en vista de que los deployments de Kubernetes generan un Load Balancer de AWS
### el cual no pudo ser obtenido desde Terraform, se debera conectar via SSH al bastion
### para obtener la URL y poder acceder a Online-Boutique.

# Comando para conectar via SSH al bastion
# ssh -i "key-name.pem" ec2-user@XXX.XXX.XXX.XXX

# Comando para obtener Endpoint del ELB desde el Bastion:
# kubectl get -o json svc frontend-external | grep hostname
