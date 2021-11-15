terraform {
  required_providers {
    aws = {
      version = "~> 2.13.0"
    }
    random = {
      version = ">= 2.1.2"
    }
  }

  required_version = "~> 1.0.11"
}

provider "aws" {
  region = "us-west-2"
}

provider "random" {}

resource "random_pet" "name" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  subnet_id = "subnet-0c8b34a17761b1d5d"

  tags = {
    Name = random_pet.name.id
  }
}
