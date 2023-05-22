output "dns_publica_servidor" {
    description = "DNS PUBLICA DEL servidor"
    value = [ for servidor in aws_instance.instance_tf :
    "http://${servidor.public_dns}:${var.puerto_servidor}"
    ]
}


output "dns_load_balancer" {
    description = "DNS PUBLICA del LOAD BALANCER"
    value = module.loadBalancer.dns_load_balancer
    }


output "zone_id_load_balancer" {
    description = "zone id_load_balancer "
    value = module.loadBalancer.zone_id_lb
    }

