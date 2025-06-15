output "host_zone" {
  value = {
    id   = aws_route53_zone.main.id,
    name = aws_route53_zone.main.name
  }
}
