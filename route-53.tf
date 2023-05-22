
# terraform aws data hosted zone
data "aws_route53_zone" "hosted_zone" {
 // provider = "aws.dns_zones"
  name = var.domain_name
  private_zone = false

}

# terraform aws route 53 record
resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = module.loadBalancer.dns_lb
    zone_id                = module.loadBalancer.zone_id_lb
    evaluate_target_health = true
  }
}