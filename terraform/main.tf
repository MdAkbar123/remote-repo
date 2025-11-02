##################################################
# Terraform: AWS EC2 Infrastructure for Node.js CI/CD
##################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  #access_key = var.aws_access_key
  #secret_key = var.aws_secret_key
}

# Create a security group allowing SSH + HTTP
resource "aws_security_group" "node_sg" {
  name        = "node-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["157.50.138.169/32"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-sg"
  }
}

# Key Pair (assumes you have a local SSH key file)
resource "aws_key_pair" "node_key" {
  key_name   = "node-key"
  public_key = file(var.public_key_path)
}

# Create EC2 Instance
resource "aws_instance" "node_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.node_key.key_name
  security_groups = [aws_security_group.node_sg.name]

  tags = {
    Name = "nodejs-ci-cd-server"
  }

  # Optional: user_data for basic bootstrap (Ansible will handle rest)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y python3
              EOF
}

# Elastic IP (optional, ensures fixed IP)
resource "aws_eip" "node_eip" {
  instance = aws_instance.node_instance.id
  depends_on = [aws_instance.node_instance]
}
