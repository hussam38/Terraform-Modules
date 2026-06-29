locals {
  public_subnets = {
    for key, value in var.subnet_config : key => value if value.public
  }
}

# Get Region Availability Zones ["us-east-1"]
data "aws_availability_zones" "azs" {
  state = "available"
}

#####################################
################ VPC ################
#####################################
resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

#####################################
############# Subnets ###############
#####################################
resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  vpc_id            = aws_vpc.this.id
  tags = {
    Name = each.value.name
    Access = each.value.public ? "Public" : "Private"
  }
  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.azs.names, each.value.az)
      error_message = <<-EOF
      The AZ you entered ${each.value.az} is not supported in region: ${data.aws_availability_zones.azs.id}
      The supported AZs are [${join(",", data.aws_availability_zones.azs.names)}]
      EOF 
    }
  }
}

#####################################
################ IGW ################
#####################################
resource "aws_internet_gateway" "igw" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_config.name}-IGW"
  }
}

#####################################
############ Route Table ############
#####################################
resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  route {
    gateway_id = aws_internet_gateway.igw[0].id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "${var.vpc_config.name}-rtb"
  }
}

#####################################
###### Route Table Association ######
#####################################
resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}