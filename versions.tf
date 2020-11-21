terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.1.0"
        }
    }
    required_version = ">= 0.13"
}