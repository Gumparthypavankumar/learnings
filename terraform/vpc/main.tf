provider "aws" {
  profile = "sandbox"
  region  = var.aws_region
}

locals {
  required_tags = var.required_tags

  resource_tags = {
    Environment = "${terraform.workspace}"
    CreatedAt   = timestamp()
  }

  tags = merge(local.required_tags, local.resource_tags)
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    local.tags, {
      Name = "vpc-${var.organization}-${terraform.workspace}"
    }
  )
}

# SUBNETS
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.availability_zones[*], count.index)
  cidr_block        = element(var.public_subnet_cidrs[*], count.index)
  tags = merge(
    local.tags, {
      Name = "subnet-${var.organization}-public-${count.index}-${terraform.workspace}"
    }
  )
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.availability_zones[*], count.index)
  cidr_block        = element(var.private_subnet_cidrs[*], count.index)
  tags = merge(
    local.tags, {
      Name = "subnet-${var.organization}-private-${count.index}-${terraform.workspace}"
    }
  )
}

resource "aws_subnet" "persistence_subnets" {
  count = length(var.persistence_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.availability_zones[*], count.index)
  cidr_block        = element(var.persistence_subnet_cidrs[*], count.index)
  tags = merge(
    local.tags, {
      Name = "subnet-${var.organization}-persistence-${count.index}-${terraform.workspace}"
    }
  )
}

# Gaateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id


  tags = merge(
    local.tags, {
      Name = "igw-${var.organization}-${terraform.workspace}"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  subnet_id = data.aws_subnet.public_subnets.id
  allocation_id = aws_eip.nat-ip.id
  tags = merge(
    local.tags, {
      Name = "nat-${var.organization}-${terraform.workspace}"
    }
  )
}

resource "aws_eip" "nat-ip" {}

# Route Tables
data "aws_subnet" "public_subnets" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  filter {
    name = "tag:Name"
    values = ["subnet-${var.organization}-public-1-${terraform.workspace}"]
  }
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.tags, {
      Name = "rtb-${var.organization}-public-${terraform.workspace}"
    }
  )
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.tags, {
      Name = "rtb-${var.organization}-private-${terraform.workspace}"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "persistence_subnet_asso" {
  count = length(var.persistence_subnet_cidrs)
  subnet_id      = element(aws_subnet.persistence_subnets[*].id, count.index)
  route_table_id = aws_route_table.rt-private.id
}