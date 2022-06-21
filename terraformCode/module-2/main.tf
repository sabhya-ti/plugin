resource "aws_instance" "showcase-1" {

  ami                    = "ami-0767046d1677be5a0"
  instance_type          = "t2.micro"
  key_name               = "aws_key"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    resource_id          = "showcase-5"
    git_commit           = "N/A"
    git_file             = "module-2/main.tf"
    git_last_modified_at = "2022-06-21 16:39:42"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "9a8462e2-af81-4be5-9fe3-122763c415b8"
  }

  user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is module-2 at instance id `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
      EOF
}

resource "aws_security_group" "main" {
  name        = "EC2-webserver-SG-1"
  description = "Webserver for EC2 Instances"

  tags = {
    "resource-id"        = "showcase-5"
    git_commit           = "N/A"
    git_file             = "module-2/main.tf"
    git_last_modified_at = "2022-06-21 16:39:42"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "17b28048-2182-4ed8-a920-fe31a4b7349b"
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
    git_file             = "module-2/main.tf"
    git_last_modified_at = "2022-06-10 12:29:12"
    git_last_modified_by = "sabhya.1802@gmail.com"
    git_modifiers        = "sabhya.1802"
    git_org              = "sabhya-ti"
    git_repo             = "tflint-ruleset-try2"
    yor_trace            = "f5f20fce-d583-47f6-8d0f-c5359300269a"
  }
}
