provider "aws" {
  region = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "rails_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rails-monitoring-vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "rails_igw" {
  vpc_id = aws_vpc.rails_vpc.id

  tags = {
    Name = "rails-monitoring-igw"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.rails_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "rails-monitoring-public-subnet"
  }
}

# Create a route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.rails_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rails_igw.id
  }

  tags = {
    Name = "rails-monitoring-public-rt"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "public_route_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group for the EC2 instance
resource "aws_security_group" "rails_sg" {
  name        = "rails-monitoring-sg"
  description = "Security group for Rails monitoring application"
  vpc_id      = aws_vpc.rails_vpc.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rails server
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rails-monitoring-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "rails_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.rails_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = file("${path.module}/../scripts/docker.sh")

  tags = {
    Name = "rails-monitoring-server"
  }
}

# Create an Elastic IP for the EC2 instance
resource "aws_eip" "rails_eip" {
  domain = "vpc"
  tags = {
    Name = "rails-monitoring-eip"
  }
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "rails_eip_assoc" {
  instance_id   = aws_instance.rails_server.id
  allocation_id = aws_eip.rails_eip.id
}

