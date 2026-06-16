terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    } 
  }
}

provider "aws" {
    region = "us-east-1"

}

resource "random_id" "rand_id" {
  byte_length = 8
}

output "name" {
    value = random_id.rand_id.hex
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.bucket
  source = "./myfile.txt"
  key    = "my-object.txt"
}
