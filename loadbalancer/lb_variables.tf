
variable "subnet_id"{
    description = "Todos los id de los subnets donde se aprovisionara el LB"
    type        = set(string)
}

variable "instancias_id"{
    description = "Id de las instancias EC2"
    type        = list(string)

}

variable "puerto_servidor"{
   description  = "Puerto para la instancia EC2"
    type        = number
   // default     = 8080

}


variable "puerto_lb"{
    description  = "Puerto para el Load Balancer"
    type        = number
 //   default     = 80
}
