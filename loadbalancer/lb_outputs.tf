output "dns_load_balancer" {
    description = "DNS PUBLICA del LOAD BALANCER"
    value = "http://${aws_lb.alb_tf.dns_name}:${var.puerto_lb}"
}


output "security_groups_alb" {
    description = "security_groups_alb"
    value = aws_security_group.sg_alb_terraform_test.id
}

output "zone_id_lb" {
    description = "zona ID del LOAD BALANCER"
    value = aws_lb.alb_tf.zone_id
}

output "dns_lb" {
    description = "DNS PUBLICA del LOAD BALANCER"
    value = aws_lb.alb_tf.dns_name
}

