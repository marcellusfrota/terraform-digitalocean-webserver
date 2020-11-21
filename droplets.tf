#
# sudo terraform plan -var "do_token=$DO_PAT" -var "domain_name=fiveheads.com.br" -var "sub_domain=agile" -var "ssl_email=marcellusfrota@gmail.com" -out server_agile
# sudo terraform apply server_agile
#

# resource "digitalocean_ssh_key" "web-ssh" {
#     name       = "terraform-ssh"
#     public_key = file("/root/.ssh/id_rsa.pub")
# }

data "digitalocean_ssh_key" "ssh_key" {
    name = "WSL Debian"
}

# resource "digitalocean_project" "playground" {
#     name        = "playground"
#     description = "A project to represent development resources."
#     purpose     = "Web Application"
#     environment = "Development"
#     resources   = [digitalocean_droplet.web.urn]
# }

resource "digitalocean_droplet" "web" {

    # (Required) The Droplet name.
    name                = "${data.external.droplet_name.result.name}-${var.do_region}"
    
    # In this section, you’ll create multiple instances of the same resource 
    # using the count key. The count key is a parameter available on all 
    # resources that specifies how many instances of it to create.
    # To avoid problems, use only two or more!
    # count               = 2

    # (Required) The Droplet image ID or slug.
    image              = var.do_image

    # (Required) The region to start in.
    region             = var.do_region

    # (Required) The unique slug that indentifies the type of Droplet.
    # Current all DigitalOcean sizes's price in https://www.digitalocean.com/pricing/
    size               = var.do_size

    # (Optional) A list of SSH IDs or fingerprints to enable in the format [12345, 123456].
    # See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
    # ssh_keys = [eb:32:13:e9:79:b0:04:43:24:ba:64:9e:32:15:5c:9a]
    ssh_keys = [
        data.digitalocean_ssh_key.ssh_key.fingerprint,
        # digitalocean_ssh_key.web-ssh.id
    ]

    # (Optional) - A list of the IDs of each block storage volume to be attached to the Droplet.
    volume_ids = []

    # (Optional) Boolean controlling whether monitoring agent is installed. 
    # Defaults to false.
    monitoring         = false
    
    # (Optional) Boolean controlling if private networking is enabled. 
    # When VPC is enabled on an account, this will provision the Droplet 
    # inside of your account's default VPC for the region. Use the vpc_uuid 
    # attribute to specify a different VPC.
    private_networking = true
    
    # (Optional) Boolean controlling if backups are made. Defaults to false.
    backups            = false
    
    # (Optional) Boolean controlling if IPv6 is enabled. Defaults to false.
    ipv6               = true

    # (Optional) The ID of the VPC where the Droplet will be located.
    # vpc_uuid           = "12341234-1234-1234-1234-123412341234"
    
    # (Optional) Boolean controlling whether to increase the disk size 
    # when resizing a Droplet. It defaults to true. When set to false, 
    # only the Droplet's RAM and CPU will be resized. Increasing a Droplet's 
    # disk size is a permanent change. Increasing only RAM and CPU is reversible.
    resize_disk        = true

    # public_domain      = var.domain_name

    # user_data = <<EOF
    #     #! /bin/bash
    #     sudo yum update -y
    #     sudo yum install -y nginx
    # EOF

    # (Optional) A list of the tags to be applied to this Droplet.
    tags = ["Terraform", "Automation"]

    ## Provisioners

    ## General connections
    connection {
        type = "ssh"
        host = self.ipv4_address
        user = var.ssh_user
        private_key = file(var.private_key)
        timeout  = "2m"
        # agent = "true"
    }        

    # The local-exec provisioner invokes a local executable after a resource is created.
    provisioner "local-exec" {
        command = "echo ${digitalocean_droplet.web.ipv4_address} >> private_ips.txt"
        on_failure = continue
    }    

    # provisioner "local-exec" {
    #     command = "echo ${data.external.pass_gen.result.password} | tee root_password.txt"
    #     on_failure = continue
    # }


    provisioner "remote-exec" {

        # connection {
        #     # type = "ssh"
        #     # host = self.public_ip
        #     # user = "root"
        #     private_key = file(var.private_key)
        #     timeout  = "2m"
        # }

        inline = [
            "export PATH=$PATH:/usr/bin",
            "sudo sysctl vm.vfs_cache_pressure=50",

            "",
            
            # Creating Swap File
            "sudo dd if=/dev/zero of=/swapfile count=4096 bs=1MiB",
            "sudo chmod 600 /swapfile",
            "sudo mkswap /swapfile",
            "sudo swapon /swapfile",
            "sudo echo '/swapfile   swap    swap    sw  0   0' >> /etc/fstab",

            # Update DNF
            "sudo dnf update -y",

            #
            ## INSTALLING PACKAGES ##
            #
            # Install Firewall
            "sudo dnf install firewalld -y",
            # Install GIT
            "sudo dnf install git -y",
            # Install NGINX
            "sudo dnf install nginx -y",
            "sudo dnf install mod_ssl -y",
            # Install PHP
            "sudo dnf install epel-release -y",
            "sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y",
            "sudo dnf module enable php:remi-7.4",
            "sudo dnf install php php-fpm php-cli php-gd php-common php-mysql -y",
            # Install MySQL
            "sudo dnf install mysql-server -y",
            # Install Composer
            "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"",
            "php composer-setup.php --install-dir=/usr/local/bin --filename=composer",
            # Install NPM
            "sudo dnf install npm -y",
            # Install Nano
            "sudo dnf install nano -y",
            
            # Enable on system services
            "sudo systemctl enable firewalld",
            "sudo systemctl enable nginx",
            "sudo systemctl enable php-fpm",
            "sudo systemctl enable mysqld",
            
            # Start & Config Firewall
            "sudo systemctl start firewalld",
            "sudo firewall-cmd --permanent --add-service=http",
            "sudo firewall-cmd --permanent --add-service=https",
            # "sudo firewall-cmd --set-log-denied=all",
            # "sudo firewall-cmd --zone=public --add-port=443/tcp",

            # Install SSL via CertBot
            "sudo curl -O https://dl.eff.org/certbot-auto",
            "sudo mv certbot-auto /usr/local/bin/certbot-auto",
            "sudo chmod 0755 /usr/local/bin/certbot-auto",
            "sudo /usr/local/bin/certbot-auto -n --nginx --domains ${var.sub_domain}.${var.domain_name} --email ${var.ssl_email} --agree-tos",

            # Start LAMP
            "sudo fuser -k 80/tcp",
            "sudo systemctl start nginx",
            "sudo systemctl start php-fpm",
            "sudo systemctl start mysqld.service",
            # "sudo setsebool -P httpd_can_network_connect 1",

            # Make index default
            "sudo setenforce 0",
            "sudo mkdir -p /var/www/html/${var.sub_domain}.${var.domain_name}",
            "echo '<h1>Deployed via Terraform</h1>' | sudo tee /var/www/html/${var.sub_domain}.${var.domain_name}/index.html"
        ]

    }

    # Copy some files
    provisioner "file" {
        source      = "conf/default.conf"
        destination = "/etc/nginx/conf.d/${var.domain_name}.conf"
    }

    provisioner "file" {
        source      = "conf/firewall.xml"
        destination = "/etc/firewalld/services/default_firewall.xml"
    }

    provisioner "remote-exec" {
        inline = [
            # Replace SUB_DOMAIN and DOMAIN_NAME defined by user
            "sudo sed -i 's/DOMAIN_NAME/${var.domain_name}/g' /etc/nginx/conf.d/${var.sub_domain}.${var.domain_name}.conf",
            "sudo sed -i 's/SUB_DOMAIN/${var.sub_domain}/g' /etc/nginx/conf.d/${var.sub_domain}.${var.domain_name}.conf",
            # Disable password authentication with SSH
            "sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config",
            # Change root password
            "echo -e ${data.external.root_pass_gen.result.password} | sudo passwd --stdin root",
            # Reload firewall
            "sudo firewall-cmd --reload",
            # "sudo systemctl restart firewalld.service",
        ]
    }

}

# resource "digitalocean_firewall" "web" {

#     # https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall

#     name                 = "${data.external.droplet_name.result.name}-${var.do_region}-firewall"

#     droplet_ids          = [
#         digitalocean_droplet.web.id
#     ]

#     inbound_rule {
#         protocol         = "tcp"
#         port_range       = "22"
#         source_addresses = ["192.168.1.0/24", "2002:1:2::/48"]
#     }

#     inbound_rule {
#         protocol         = "tcp"
#         port_range       = "80"
#         source_addresses = ["0.0.0.0/0", "::/0"]
#     }

#     outbound_rule {
#         protocol              = "tcp"
#         port_range            = "53"
#         destination_addresses = ["0.0.0.0/0", "::/0"]
#     }

#     outbound_rule {
#         protocol              = "udp"
#         port_range            = "53"
#         destination_addresses = ["0.0.0.0/0", "::/0"]
#     }

#     outbound_rule {
#         protocol              = "icmp"
#         destination_addresses = ["0.0.0.0/0", "::/0"]
#     }

# }


# resource "digitalocean_droplet" "database" {

#     image               = var.do_image
#     name                = "${data.external.droplet_name.result.name}-${var.do_region}-db"

#     region              = var.do_region
#     size                = var.do_size

#     ssh_keys = [
#         data.digitalocean_ssh_key.ssh_key.id
#     ]

# }

# resource "digitalocean_loadbalancer" "public_loadbalancer" {
    
#     name              = "${data.external.droplet_name.result.name}-${var.do_region}-loadbalancer"
#     region            = var.do_region

#     forwarding_rule {

#         entry_port     = 443
#         entry_protocol = "https"

#         target_port     = 80
#         target_protocol = "http"

#         certificate_name = digitalocean_certificate.cert.name

#     }

#     # forwarding_rules = [
#     #     {
#     #         entry_port = 80,
#     #         entry_protocol = "http",
#     #         target_port = 80,
#     #         target_protocol = "http",
#     #         tls_passthrough = false
#     #     },
#     #     {
#     #         entry_port = 444,
#     #         entry_protocol = "https",
#     #         target_port = 443,
#     #         target_protocol = "https",
#     #         tls_passthrough = true
#     #     }
#     # ]    

#     healthcheck {
#         port     = 22
#         protocol = "tcp"
#     }

#     algorithm   = "round_robin"

#     # It'll be used with multiple instances of droplet"
#     # droplet_ids = ["${digitalocean_droplet.web.*.id}"]

#     droplet_ids = [
#         digitalocean_droplet.web.id
#     ]
# }

# resource "digitalocean_tag" "ENV_prod" {
#     name = "ENV:prod"
# }

# resource "digitalocean_tag" "ROLE_web" {
#     name = "ROLE:web"
# }