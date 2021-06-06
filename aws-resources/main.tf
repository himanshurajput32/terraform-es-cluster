provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "lambda_test_vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "lambda_test_igw"
  }
}

resource "aws_subnet" "lambda_test_pub" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  tags = {
    Name = "lambda_test_subnet_pub"
  }
}

resource "aws_subnet" "lambda_test_pri" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "lambda_test_subnet_pri"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "lambda_test_public_rt"
  }
}

resource "aws_route_table_association" "first" {
  subnet_id      = aws_subnet.lambda_test_pub.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "this" {
  vpc      = true
  depends_on  = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "lambda_test_ngw" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.lambda_test_pub.id
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name = "lambda_test_ngw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lambda_test_ngw.id
  }
  tags = {
    Name = "lambda_test_private_rt"
  }
  depends_on = [aws_nat_gateway.lambda_test_ngw]
}

resource "aws_route_table_association" "second" {
  subnet_id      = aws_subnet.lambda_test_pri.id
  route_table_id = aws_route_table.private.id
  depends_on = [aws_route_table.private]
}

resource "aws_security_group" "this" {
  name        = "SSH-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SSH-sg"
  }
}

resource "aws_key_pair" "lambda_test" {
  key_name = "lambda_test_key"
  public_key = var.public_key
}

module "ec2" {
  source = "../modules/ec2"
  name = "lambda_test_ec2_pri"
  instance_count = var.instance_count
  ami = var.ami
  subnet_id = aws_subnet.lambda_test_pri.id
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  monitoring = var.monitoring
  key_name = aws_key_pair.lambda_test.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  root_block_device = [
    {
      volume_size = 20
      volume_type = "gp2"
    }
  ]

  tags = {
    Project: "test"
    Resource: "ec2"
    Managed: "terraform"
  }


}

