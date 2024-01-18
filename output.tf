#Send back these variables to the user
output "alb_dns_name" {
value       = module.compute.alb_dns_name
}