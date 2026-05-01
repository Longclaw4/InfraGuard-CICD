provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "infraguard_sg" {
  name        = "infraguard-sg"
  description = "InfraGuard secure SSH group"

  ingress {
    description = "Restricted SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "InfraGuard-SG"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.infraguard_sg.id]

  tags = {
    Name = "InfraGuard-Server"
  }
}

resource "aws_s3_bucket" "dashboard" {
  bucket = "infraguard-vaibhav-1551-demo"
}
