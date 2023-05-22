
variable "tipo_instancia"{
    description = "Tipo de instancia de EC2"
    type        = string
    default     = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "terraform-keypair-new"
}


# Declaracion de variable con VALIDACION
variable "puerto_servidor"{
   description  = "Puerto para la instancia EC2"
    type        = number
    default     = 8080


}

variable "puerto_lb"{
   description  = "Puerto para la instancia EC2"
    type        = number
    default     = 80
}



# Declaracion de variable MAP para la AMI
variable "ubuntu_ami"{
     description = "AMI por region"
     type        = map(string)
     
     default = {
            us-east-1    = "ami-09cd747c78a9add63" #ubuntu Virgina
            ca-central-1 = "ami-00842a994f5018db8" #ubutu Canada
     }   
}


## SE Declada Variable que permiterar iterar los servidores

variable "servidores" {
     description = "AMI por region"
     type        = map(object({
        name = string,
        az     = string
     }))

     default = {
        "ser-1" = { name="Instance-1", az="a"}
        "ser-2" = { name="Instance-2", az="b"}
     }
}



variable "domain_name"{
   description  = "Domain name"
    type        = string
    default     = "carlosperaza.com"
}

variable "record_name"{
   description  = "Sub domain name"
    type        = string
    default     = "www"
}






