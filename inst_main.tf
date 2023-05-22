provider "aws" {
    region= local.region
}

locals {
    region = "us-east-1"
}


data "aws_subnet" "public_subnet"{
    for_each = var.servidores
    availability_zone = "${local.region}${each.value.az}"
}


##############################   I N S T A N C I A      E C 2    ################################################
resource "aws_instance" "instance_tf"{
     for_each = var.servidores
     ami           = data.aws_ami.fetch_ami.id
     instance_type = "t2.micro"
     subnet_id = data.aws_subnet.public_subnet[each.key].id     # each.key es ser-1 o ser-2
     vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]
     key_name = var.key_name
     user_data = <<-EOF
                #!/bin/bash
                echo "Se ha levantado las instancia!" Este representa la    ${each.value.name} > index.html
                nohup busybox httpd -f -p ${var.puerto_servidor} &
                EOF

    tags = {
        Name = each.value.name
    }

}


## SG de las instancias
resource "aws_security_group" "mi_grupo_de_seguridad"{
    name = "servidor-sg-instancias"
    
    ingress {
        //cidr_blocks = ["0.0.0.0/0"]
        // Se config solo para que el SG tenga acceso el loadbalancer a nuestros servidores
        security_groups = [module.loadBalancer.security_groups_alb]
        description     = "Acceso al puerto 8080 desde el exterior"
        from_port       = var.puerto_servidor
        to_port         = var.puerto_servidor
        protocol        = "TCP"
    }
}


############ MODULE #######################


##############################   LOAD BALANCER    ################################################

module "loadBalancer"{
    source = "./loadbalancer"

    subnet_id       = [for subnet in data.aws_subnet.public_subnet : subnet.id]
    instancias_id   = [for inst in aws_instance.instance_tf : inst.id]
    puerto_lb       = var.puerto_lb
    puerto_servidor = var.puerto_servidor
}







#######   AMI FETCH #########

data "aws_ami" "fetch_ami" {
  most_recent      = true
  owners           = ["679593333241"]

  filter {
    name   = "name"
    values = ["Wordpress on Ubuntu One Click Deployment-e943c1ac-1412-491f-81ac-910ebb69aacc"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output ami_id {
    value = data.aws_ami.fetch_ami.id
}