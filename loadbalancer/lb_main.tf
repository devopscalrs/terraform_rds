## Se crea el load balancer con las instacias asociadas a la subnet
resource "aws_lb" "alb_tf"{
    name = "sre-ALB"
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg_alb_terraform_test.id]
    subnets = var.subnet_id
}


## se crea SG del load Balancer
resource "aws_security_group" "sg_alb_terraform_test"{
    name = "SRE-alb-securityGroup"

    //Solicitud de entrada
    ingress{
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso al puerto 80 desde el exterior"
        from_port = var.puerto_lb
        to_port= var.puerto_lb
        protocol = "TCP"
    }

  //Solicitud de salida a las instancias
    egress{
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso al puerto 8080 de nuestras instancias"
        from_port = var.puerto_servidor
        to_port= var.puerto_servidor
        protocol = "TCP"
    }

}

data "aws_vpc" "default"{
    default = true
}



// Se crea TARGET_GROUP que nos permite enrutar trafico desde el loadbalancer a nuestras instancias
resource "aws_lb_target_group" "this"{
    name = "SRE-alb-TargetGroup"
    port = var.puerto_lb
    vpc_id = data.aws_vpc.default.id
    protocol = "HTTP"

    health_check {
        enabled   = true
        matcher  = "200"
        path    = "/"
        port     = var.puerto_servidor
        protocol = "HTTP"
    }
}



//Se crea los attachment para especificar que nuestras instacias se conecta al Target_group
resource "aws_lb_target_group_attachment" "servidor"{
    count = length(var.instancias_id)
  //(())  for_each = var.instancias_id
    target_group_arn = aws_lb_target_group.this.arn
    target_id        = element(var.instancias_id, count.index)
    port             = var.puerto_servidor
}




// Se crea listener para filtrar todas las solicitudes entrantes al Lb y las redireccione a otro puerto que seria el LB
resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.alb_tf.arn
    port              = var.puerto_lb
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.this.arn
    }
}