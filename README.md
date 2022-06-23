<p align="center">
<img src="src/frontend/static/icons/Hipster_HeroLogoCyan.svg" width="300" alt="Online Boutique" />
</p>

# Descripción de la solución

Este repositorio, y la documentación contenida en él, representan la entrega final del trabajo práctico correspondiente a la asignatura *Implementación de Soluciones cloud*, dentro del marco del quinto semestre de la carrera *Analista en Infraestructura Informática*, en la *Universidad ORT Uruguay*.

Con la información contenida en el repositorio, el usuario estará en capacidad de hacer un deploy automatizado de la web Online Boutique, haciendo uso únicamente del comando *terraform apply*

## Dinámica de trabajo

En primer lugar, se generó un repositorio público basado en el [contenido](https://github.com/ISC-ORT-FI/online-boutique) brindado por los docentes. 

Luego de esto, se asignaron permisos de edición a todos los integrantes del grupo, para poder trabajar de manera colaborativa.

Se personalizó el archivo .gitignore para que todos los archivos referentes a cada workspace de Terraform no sean incluidos en cada uno de los commits realizados.
Una vez que cada integrante logró clonar el repositorio de manera local en su PC, se procedió a desarrollar los componentes de la infraestructura a desplegar, tratando de adoptar el siguiente orden:
1. Componentes de networking, desde lo más grande hasta lo más específico
1.1 VPC
1.2 Internet Gateway
1.3 Subnets
1.4 Security Group
2. Componentes de Kubernetes (EKS)
2.1 EKS Cluster
2.2 EKS Node Group
3. Instancia Bastión 

Al lograr un despliegue exitoso de toda la infraestructura, se procedió a crear un Script para aprovisionar el Bastión. En esta etapa se describieron las acciones que se necesitaba realizar para lograr que la instancia esté en capacidad de desplegar automáticamente la web Online Boutique:
* Actualizar todos los paquetes del sistema a su versión más reciente
* Instalación de dependencias necesarias para una correcta interacción con todos los servicios que se requieren para hacer el despliegue (Git, Docker, Kubernetes v1.21.1)
* Clonado del repositorio para tener los archivos necesarios para realizar el despliegue de los microservicios
* Carga de credenciales de AWS en los archivos *config* y *credentials*, para una correcta interacción con los servicios de Amazon
* Conexión al contexto del Cluster de EKS creado previamente
* Ejecución de comandos que permiten el despliegue de los microservicios


## Componentes de infraestructura
Para lograr el despliegue de la infraestructura donde se alojará Online Boutique, se crearon los siguientes componentes de infraestuctura en Amazon Web Services:
* VPC
* Dos subnets, alojadas en diferentes Zonas de Disponibilidad
* Internet Gateway
* Route Table
* Elastic Kubernetes Service Cluster
* Elastic Kubernetes Service Node Group
* Instancia EC2, la cual cumplirá la función de Bastión para el deploy de los microservicios
* Security Group para acceso vía SSH al Bastión


## Diagrama de Arquitectura

**Online Boutique** es una implementación cloud de microservicios que se encarga de generar una página web de compras online, integrando diversos servicios escalables e independientes que permiten al usuario simular una experiencia real de compra digital, con la posibilidad de buscar artículos, añadirlos a su carrito y realizar la compra de los mismos. Soporta el uso de varios tipos de divisa, carga de datos de tarjetas de crédito, etc.

[![Arquitectura de la solución](./docs/img/architecture-diagram.png)](./docs/img/architecture-diagram.png)


> **⚠ ATENCION: CAMBIOS A REALIZAR PARA IMPLEMENTAR DESDE DIFERENTES HOSTS⚠**  
> En vista de las limitaciones que conlleva trabajar con AWS Academy, cada uno de los integrantes deberá realizar ciertas modificaciones para poder hacer el deploy automatizado de la infraestructura, las cuales se detallan a continuación:
> * Ingresar las credenciales de AWS en el archivo iac/provision.sh para que el equipo Bastión pueda conectarse correctamente a la cuenta que se requiera utilizar
> * Modificar el Role ARN en los archivos iac/eks-cluster.tf e iac/eks-ng.tf. Esto se debe a que las cuentas Academy de AWS no permiten gestionar permisos para usuarios y roles, por lo que deberán ingresar de forma manual en cada cuenta.


> **CAMBIOS REFERENTES A ECR Y DOCKERHUB** 
> Con el fin de utilizar la mayor cantidad de recursos de AWS posibles, la implementación actual contempla la obtención de las imágenes de Docker (necesarias para realizar el deploy de los microservicios) desde un repositorio implementado bajo el servicio Elastic Container Registry de AWS.
Sin embargo, las cuentas AWS Academy permiten crear únicamente repositorios privados, por lo que ningún usuario diferente del dueño del repositorio podrá acceder al mismo, salvo que se le otorguen permisos para hacer un pull de las imágenes.
A efectos de optimizar el trabajo colaborativo, se otorgaron permisos de lectura para todos los integrantes del equipo por medio de la siguiente Policy de acceso: 
```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "id-account-access",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT-UNIQUE-ID:root"
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages"
      ]
    }
  ]
}
```

>En vista de que resulta inviable asignar permisos de lectura a todas las personas que quieran desplegar la aplicación, se deja también una alternativa con un repositorio de acceso público en la Registry DockerHub.
Para lograr el cambio de repositorio, lo único que se deberá hacer es modificar el Manifiesto de Kubernetes de cada uno de los servicios, haciendo los siguientes cambios:
>![Screenshot de tabla de cambios](./docs/img/tabla-ecr-dockerhub.png)
Una vez realizadas esas modificaciones, se podrá hacer un pull de las imágenes alojadas en el repositorio público de DockerHub.
>**Nota:** En el servicio de caché (Redis) no se debe realizar ningún cambio ya que este servicio utiliza la imagen pública *redis:alpine*


## Screenshots

| Página Inicial                                                                                                        | Página de Checkout                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](./docs/img/online-boutique-frontend-1.png)](./docs/img/online-boutique-frontend-1.png) | [![Screenshot of checkout screen](./docs/img/online-boutique-frontend-2.png)](./docs/img/online-boutique-frontend-2.png) |

## Requerimientos para deploy

Para desplegar la infraestructura y la web Online Boutique, el administrador deberá contar con una estación que tenga los siguientes componentes funcionando:
* AWS cli, con credenciales actualizadas
* Terraform v1.2.3

## Instrucciones para deploy

A continuación se describen los pasos a seguir para lograr el despliegue de Online Boutique haciendo uso del repositorio actual

1. Clonar el repositorio (git clone https://github.com/ricardosanchezr96/obligatorio-isc.git)
2. Editar los archivos mencionados en el bloque anterior, para que no exista conflicto alguno al momento de realizar la ejecución
3. Posicionarse sobre el directorio *iac* del repositorio clonado
4. Ejecutar el comando `terraform init` para inicializar el working directory de Terraform con los datos del provider (en este caso, AWS)
5. Ejecutar `terraform plan` y verificar que la salida del comando indique que se crearán 9 recursos de infraestructura en AWS.
6. Ejecutar `terraform apply` para que se cree la infraestructura
> Nota: Al ejecutar el apply de Terraform, se debe tomar en consideración los tiempos aproximados que tarda en crear algunos recursos:
> * EKS Cluster: 10 minutos
> * EKS Node Group: 3 minutos
> * Instancia Bastión: 2 minutos
Se debe tener en consideración que una interrupción forzada en la ejecución de Terraform antes de que finalice puede ocasionar que los archivos de estado queden corruptos y que se tenga que eliminar toda la infraestructura manualmente para poder continuar con el despliegue.
7. Una vez finalizado el despliegue de infraestructura por parte de Terraform, se deberá esperar que la consola de AWS indique que el Bastión superó exitosamente todos los chequeos de salud. Esto indica que el aprovisionamiento se realizó correctamente, y que los pods de Kubernetes están operativos.
8. Conectarse vía SSH al bastión para obtener el endpoint del Load Balancer creado por Kubernetes, el cual permitirá acceder a Online Boutique desde cualquier navegador web
`ssh -i "key-name.pem" ec2-user@XXX.XXX.XXX.XXX`
9. Una vez conectado al Bastión, se deberá introducir el comando `kubectl get -o json svc frontend-external | grep hostname` para obtener el endpoint y poder acceder a Online Boutique

## Pruebas de funcionamiento

gif con tf apply
gif obteniendo url de la web
gif haciendo compra


## Dificultades
explicar problemas y soluciones


## Limitantes

Lo que no pudimos solucionar y por que

## Futuras mejoras


#### Integrantes del grupo
* Martín Pacheco - Número de estudiante 263651
* Ricardo Sánchez - Número de estudiante 255864

#### Referencias bibliográficas

#### Declaración de autoría

Por la siguiente, Martín Pacheco y Ricardo Sánchez, con números de estudiante 263651 y 255864 respectivamente, estudiantes de la carrera Analista en Infraestructura Informática en relación con el trabajo obligatorio de fin de semestre presentado para su evaluación y defensa, declaramos que asumimos la autoría de dicho documento entendida en el sentido de que no se han utilizado fuentes sin citarlas debidamente.