# resource "digitalocean_certificate" "cert" {

#     name             = "${var.domain_name}-cert"
#     type             = "lets_encrypt"

#     # type             = "custom"
#     # private_key      = file(var.cert_private_key)
#     # leaf_certificate = file(var.cert_leaf_certificate)
#     # certificate_chain = file(var.cert_fullchain")

#     domains = [
#         "test.${var.domain_name}"
#     ]

#     lifecycle {
#         create_before_destroy = true
#     }
    
# }

resource "digitalocean_domain" "web" {
    name             = var.domain_name
    ip_address       = digitalocean_droplet.web.ipv4_address
    
}

resource "digitalocean_record" "www" {
    domain = var.domain_name
    type   = "A"
    name   = var.sub_domain
    value  = digitalocean_droplet.web.ipv4_address
}