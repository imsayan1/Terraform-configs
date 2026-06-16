
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }
  }
  backend "s3" {
    bucket = "my-bucket-d16ff683ead2ebd6"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
    region = "us-east-1"

}

resource "aws_instance" "my-server" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"

  tags = {
    Name = "My-test-server"
  }
}