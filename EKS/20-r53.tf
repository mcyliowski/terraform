resource "aws_route53_zone" "main" {
  name = local.domain_name

  tags = {
    Environment = local.env
    ManagedBy   = "terraform"
  }
}

output "route53_name_servers" {
  value = aws_route53_zone.main.name_servers
}