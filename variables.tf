# ####
# project = "PROJECT_NAME_HERE"

# variable "do_token" {}
# variable "pub_key" {}
# variable "pvt_key" {}
# variable "ssh_fingerprint" {}
variable "ssh_user" {
    default     = "root"
}

variable "do_token" {
    description = "Type your DigitalOcean Personal Token"
}

variable "do_region" {
    description = "Choose a DigitalOcean's Data Center"
    default     = "nyc1"
}

variable "do_size" {
    description = "Choose a DigitalOcean Machine"
    default     = "s-1vcpu-1gb"
}

variable "do_image" {
    description = "Choose a DigitalOcean OS distribution"
    default     = "centos-8-x64"
}

variable "sub_domain" {
    description = "Type your subdomain name application"
    default     = "www"
}

variable "domain_name" {
    description = "Type your domain name application"
}

variable "ssl_email" {
    description = "Type your email to validate SSL Certificate"
    default = "meu_email@email.com"
}

variable "private_key" {
    description = "Path for your private key"
    default     = "C:\\Users\\ThinkPad\\.ssh\\id_digitalocean"
}

variable "cert_private_key" {
    description = "Path for your certificate private key"
    default     = "C:\\Server\\bin\\Apache24\\conf\\mautic.fiveheads.com.br\\server.key"
}

variable "cert_leaf_certificate" {
    description = "Path for your certificate leaf file"
    default     = "C:\\Server\\bin\\Apache24\\conf\\mautic.fiveheads.com.br\\server.crt"
}

variable "cert_fullchain" {
    description = "Path for your full certificate chain file"
    default     = "C:\\Server\\bin\\Apache24\\conf\\mautic.fiveheads.com.br\\server.crt"
}

# variable "do_region" {
#     type    = list(string)
#     default = ["nyc1", "nyc2"]
#     # validation {
#     #     condition     = length(var.do_region) > 4 && substr(var.do_region, 0, 4) == "ami-"
#     #     error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
#     # }
# }

# variable "do_region" {
#     type = map
#     default = {
#         "New York Data Center 1" = "nyc1"
#         "New York Data Center 2" = "nyc2"
#         "New York Data Center 3" = "nyc3"
#     }
# }

# variable "storage_sizes" {
#   type = map
#   default = {
#     "1xCPU-1GB"  = "25"
#     "1xCPU-2GB"  = "50"
#     "2xCPU-4GB"  = "80"
#   }
# }
# size = lookup(var.storage_sizes, var.plans["5USD"])

variable "number_servers" {
    description = "Number of server instances"
    default = "1"
}

# Current Available OS
#
# curl -s -X GET "https://api.digitalocean.com/v2/images" -H "Authorization: Bearer $DO_PAT" | jq . | grep slug
#
# As of 08-11-2020

# "slug": "centos-6-x32",
# "slug": "centos-6-x64",
# "slug": "centos-7-x64",
# "slug": "centos-8-x64",

# "slug": "ubuntu-16-04-x32",
# "slug": "ubuntu-18-04-x64",
# "slug": "ubuntu-20-04-x64",
# "slug": "ubuntu-16-04-x64",
# "slug": "ubuntu-20-10-x64",

# "slug": "freebsd-11-x64-ufs",
# "slug": "freebsd-11-x64-zfs",
# "slug": "freebsd-12-x64",
# "slug": "freebsd-12-x64-ufs",
# "slug": "freebsd-12-x64-zfs",

# "slug": "rancheros",

# "slug": "debian-9-x64",
# "slug": "debian-10-x64",

# "slug": "fedora-31-x64",
# "slug": "fedora-32-x64",
# "slug": "fedora-33-x64",

# Current Available Regions
#
# curl -s -X GET "https://api.digitalocean.com/v2/regions" -H "Authorization: Bearer $DO_PAT" | jq . | grep slug
#
# As of 08-11-2020

# "slug": "nyc1",
# "slug": "nyc2",
# "slug": "nyc3",
# "slug": "sfo1",
# "slug": "sfo2",
# "slug": "sfo3",
# "slug": "ams2",
# "slug": "ams3",
# "slug": "sgp1",
# "slug": "lon1",
# "slug": "fra1",
# "slug": "tor1",
# "slug": "blr1",