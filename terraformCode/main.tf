terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "sabhya-terraform-up-and-running-state"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "sabhya-terraform-up-and-running-locks"
    encrypt        = true
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "sabhya-terraform-up-and-running-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    yor_trace = "44c6f4af-ede1-4318-977a-d0b3f3e0a7df"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sabhya-terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    yor_trace = "763c7759-73c1-43b8-b5e3-bed6ab3e13a"
  }
}

resource "aws_instance" "showcase-1" {
  instance_type = var.ec2-instance
  ami           = "ami-09d56f8956ab235b3"
  tags = {
    yor_trace = "b58b43f2-6062-4ed0-942b-e1293ee7b0af"
  }
}

resource "aws_instance" "showcase-2" {
  instance_type = "t2.large"
  ami           = "ami-09d56f8956ab235b3"
  tags = {
    yor_trace = "14f2bc9-6311-443c-a1ea-13924dc9a1cb"
  }
}

module "server-1" {
  source            = ".//module-1"
  web_instance_type = "t2.micro"
}

module "server-2" {
  source = ".//module-2"
}
