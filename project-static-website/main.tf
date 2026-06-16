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
  backend "s3" {
    bucket = "my-bucket-d16ff683ead2ebd6"
    key    = "backend-for-project.tfstate"
    region = "us-east-1"
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

resource "aws_s3_bucket" "my_project_bucket" {
  bucket = "my-project-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_project_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "my-project" {
  bucket = aws_s3_bucket.my_project_bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.my_project_bucket.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "my_project" {
  bucket = aws_s3_bucket.my_project_bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.my_project_bucket.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.my_project_bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
  content_type = "text/css"
}

output "website_url" {
  description = "The URL of the S3 bucket website."
  value       = aws_s3_bucket_website_configuration.my_project.website_endpoint
}
