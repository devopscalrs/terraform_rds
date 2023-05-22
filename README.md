# terraform project


Ejecicio Realizado por Carlos Peraza 
www.linkedin.com/in/carlos-luis-peraza-luna-844728bb


# De Acuerdo con el ejercicio planteado se Automatizo mediante Terraform la creacion de estos componentes

- Application Load Balancer
- Security Groups
- AMI (optional encryption)
- RDS (PostgreSQL)
- R53 alias
- R53 Hosted Zone


Se Trabajo sobre Terraform levantando 2 instancias con una ami ubuntu que contine Wordpress como base en donde se asocio
1 RDS para cada 1 de las instancias, Tambien se creo su respectivo SG, ALB y R53 zone, se uso la VPC por defecto y toda su subnet
para asociar a las instancia, no fue necesario la configuracion de NAT, Intert Gateway ni route table.



 Packer : No fue posible configurar packer para la gestion de la AMI

 Ansible : Tampoco fue necesario ni posible por falta de tiempo configurar el host mediante ansible para instalar  lo necesario para el despliegue de wordpress en la instancia y sus dependencias

 Terragrunt:  no fue necesario


# Nota
Por favor considerar enviar feedback para continua mejora
