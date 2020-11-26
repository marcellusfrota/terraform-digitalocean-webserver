# Terraform + DigitalOcean + Secure Web Server

> Nginx + PHP7.4 + Python3 | MySQL | Basic Security setup with Firewalld

# Table of contents

* [DigitalOcean](#digital-ocean)
    - [Getting Credentials](#gettingcredentials)

* [Terraform](#terraform)
    - [Installing Terraform](#installingterraform)
    - [Windows](#windows)
    - [Providers](#providers)
    - [Terraform commands](#terraformcommands)
    - [Checking](#checking)

* [Secure Web Server](#securewebserver)
    - [Webserver]
    - [DigitalOcean Firewall](#bbb)
    - [Firewalld](#aaa)

* [Contributing](#contributing)
* [License](#license)


# **DigitalOcean** {#digital-ocean}

First of all, you need a DigitalOcean account, of course!
DigitalOcean is giving a U$100,00 credit for anyone who [sign up here](https://m.do.co/c/2191bf5ea930).

After this, [create a Personal Access Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/) 

## Getting Credentials

## Create Letsencrypt certificate

```sh
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
```

Output
```
Country Name (2 letter code) [AU]:**US**
State or Province Name (full name) [Some-State]:New York
Locality Name (eg, city) []:New York City
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Bouncy Castles, Inc.
Organizational Unit Name (eg, section) []:Ministry of Water Slides
Common Name (e.g. server FQDN or YOUR name) []:server_IP_address
Email Address []:admin@your_domain.com
```

```sh
$ sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```

# **Terraform**

## Installing Terraform

...

### Windows

...

### Providers

There's a lot of Provider to choose...

[List of all Terraform Providers ](https://www.terraform.io/docs/providers/)


Some of most used providers
* [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
* [AZURE](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Terraform commands

```sh
$ terraform init
```

Lemember when we exported DO_PAT? Now, you can just type:

```sh
$ terraform plan \
$  -var "do_token=${DO_PAT}" \
$  -var "private_key=$HOME/.ssh/id_rsa" \
$  -var "domain_name=${DOMAIN_NAME}"
```

You'll be asked for some variables. Or you can just setting them:

```sh
$ terraform plan \
$  -var "do_token=DO_TOKEN" \
$  -var "private_key=FILEPATH_TO_YOUR_RSA_KEY" \
$  -var "domain_name=MY_DOMAIN.COM" \
$  -var "cert_private_key=FILEPATH_TO_YOUR_CERTIFICATE" \
$  -var "cert_leaf_certificate=FILEPATH_TO_YOUR_CERTIFICATE_LEAF"
```

> **Note**: The terraform plan command supports an -out parameter to save the plan. However, the plan will store API keys, and Terraform does not encrypt this data. If you choose to use this option, you should explore encrypting this file if you plan to send it to others or leave it at rest for an extended period of time.

```sh
$ terraform apply
```

Or

```sh
$ terraform apply -var "do_token=${DO_PAT}" -var "domain_name=${DO_DOMAIN_NAME}"
```

### Checking

```sh
$ terraform show | grep "ipv4"
```

```bash
Output
ipv4_address = "YOUR_DROPLET_IP"
```



```sh
$ nslookup -type=a YOUR_DOMAIN | grep "Address" | tail -1
```


Done!

# **Secure Web Server**

# **Contributing**
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

p.s.: still waiting for a @fdavidsantos contribution!

# **License**
[MIT](https://choosealicense.com/licenses/mit/)

**Free Software, Hell Yeah!**

# **TODO**

- Implement multiple instances of a droplet
- Create new project
- Choose what project insert the resources
