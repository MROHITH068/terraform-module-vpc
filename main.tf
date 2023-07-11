resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true

  tags = merge({
    Name = "${var.env}-vpc"
  },var.tags)
}

module "subnets" {
  source = "./subnets"
  for_each = var.subnets
  subnet_name = each.key
  cidr_block = each.value["cidr_block"]
  tags = var.tags
  vpc_id = aws_vpc.main.id
  env = var.env
  az = var.az
}

resource "aws_vpc_peering_connection" "veer" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${var.env}-igw"
  }, var.tags)
}