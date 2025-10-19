resource "aws_route53_zone" "main" {
  name    = var.domain_name
  comment = "Hosted zone for ${var.domain_name}"
}

resource "aws_route53_record" "app_dns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

output "frontend_url" {
  value = "http://${aws_route53_record.app_dns.name}"
}
