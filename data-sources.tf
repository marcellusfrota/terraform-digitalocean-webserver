# Do not forget to change "droplet_name"

data "external" "droplet_name" {
    program = ["python3", "${path.module}/external/name-generator.py"]
}

data "external" "root_pass_gen" {
    program = ["python3", "${path.module}/external/password-generator.py"]
}

data "external" "default_user_pass_gen" {
    program = ["python3", "${path.module}/external/password-generator.py"]
}
