output "public_ip" {
    value = digitalocean_droplet.web.ipv4_address
}

# output "instance_ip_addr" {
#     value = {
#         for instance in digitalocean_droplet.web:
#             instance.id => instance.ipv4_address
#     }
#     description = "The IP addresses of the deployed instances, paired with their IDs."
# }

output "name" {
    value = digitalocean_droplet.web.name
}

# output "loadbalancer_ip" {
#     value = digitalocean_loadbalancer.public_loadbalancer.ipv4_address
# }

# output "db_password" {
#     value       = aws_db_instance.db.password
#     description = "The password for logging in to the database."
#     sensitive   = true
# }

# output "instance_ip_addr" {
#   value       = aws_instance.server.private_ip
#   description = "The private IP address of the main server instance."

#   depends_on = [
#     # Security group rule must be created before this IP address could
#     # actually be used, otherwise the services will be unreachable.
#     aws_security_group_rule.local_access,
#   ]
# }