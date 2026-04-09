# provider "aws" {
#   region = var.region
# }

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
  
#   tags = {
#     Name                               = "${var.project_name}-vpc"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags   = { Name = "${var.project_name}-igw" }
# }

# # --- SUBNETS ---

# resource "aws_subnet" "pub_1a" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "${var.region}a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name                               = "${var.project_name}-pub-1a"
#     "kubernetes.io/role/elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }
# }

# resource "aws_subnet" "pub_1b" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "${var.region}b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name                               = "${var.project_name}-pub-1b"
#     "kubernetes.io/role/elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }
# }

# resource "aws_subnet" "priv_1a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.10.0/24"
#   availability_zone = "${var.region}a"

#   tags = {
#     Name                               = "${var.project_name}-priv-1a"
#     "kubernetes.io/role/internal-elb"  = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }
# }

# resource "aws_subnet" "priv_1b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.11.0/24"
#   availability_zone = "${var.region}b"

#   tags = {
#     Name                               = "${var.project_name}-priv-1b"
#     "kubernetes.io/role/internal-elb"  = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }
# }

# # --- NAT GATEWAY ---

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.pub_1a.id
#   tags          = { Name = "${var.project_name}-nat" }
# }

# # --- ROUTING ---

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "pub_1a" {
#   subnet_id      = aws_subnet.pub_1a.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "pub_1b" {
#   subnet_id      = aws_subnet.pub_1b.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main.id
#   }
# }

# resource "aws_route_table_association" "priv_1a" {
#   subnet_id      = aws_subnet.priv_1a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "priv_1b" {
#   subnet_id      = aws_subnet.priv_1b.id
#   route_table_id = aws_route_table.private.id
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}