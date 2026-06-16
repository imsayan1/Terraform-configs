terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"

}

#create VPC

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

#private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
    tags = {
        Name = "private-subnet"
    }
}

#public subnet

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  tags ={
    Name = "public-subnet"
  }
}

#internet gateway

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "my-igw"
    }
}

#routing table

resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "my-rt"
    }
    #rule for routing table to allow internet access
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }

}
#route table association

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_instance" "my_server" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id


  tags = {
    Name = "My-test-server"
  }
}