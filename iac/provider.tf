# Archivo provider, donde se le indica a Terraform que 
# trabajamos con AWS, utilizando un perfil y una Region 
# previamente establecidos en el archivo de variables

provider "aws" {
  region  = var.region
  profile = var.perfil
}