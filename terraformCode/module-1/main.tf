resource "aws_instance" "showcase-1" {

  ami           = "ami-09d56f8956ab235b3"
  instance_type = var.web_instance_type
  tags = {
    git_commit           = "N/A"
    git_file             = "module-1/main.tf"
    git_last_modified_at = "2022-06-21 10:57:47"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "aa4e6dbb-a8e2-4810-97a9-19747321ea1b"
  }
}

resource "aws_security_group" "main" {
  name        = "EC2-webserver-SG-1"
  description = "Webserver for EC2 Instances"

  tags = {
    resource_id          = "showcase-4"
    git_commit           = "N/A"
    git_file             = "module-1/main.tf"
    git_last_modified_at = "2022-06-21 10:57:47"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "c99ae3bb-f504-4031-80bc-1c61b7eca247"
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["115.97.103.44/32"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbvRN/gvQBhFe+dE8p3Q865T/xTKgjqTjj56p1IIKbq8SDyOybE8ia0rMPcBLAKds+wjePIYpTtRxT9UsUbZJTgF+SGSG2dC6+ohCQpi6F3xM7ryL9fy3BNCT5aPrwbR862jcOIfv7R1xVfH8OS0WZa8DpVy5kTeutsuH5FMAmEgba4KhYLTzIdhM7UKJvNoUMRBaxAqIAThqH9Vt/iR1WpXgazoPw6dyPssa7ye6tUPRipmPTZukfpxcPlsqytXWlXm7R89xAY9OXkdPPVsrQA0XFQnY8aFb9XaZP8cm7EOVRdxMsA1DyWMVZOTjhBwCHfEIGoePAS3jFMqQjGWQd rahul@rahul-HP-ZBook-15-G2"
  tags = {
    git_commit           = "877944ea860a94dc2460ec1e311d028536350aa1"
    git_file             = "module-1/main.tf"
    git_last_modified_at = "2022-06-10 12:29:12"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "86c0d876-4aea-4032-ae70-c2a0bc1058b0"
  }
}
