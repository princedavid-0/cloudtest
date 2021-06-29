/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                      VPC
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "TestVPC"
  }
}

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                      SUBNETS
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
resource "aws_subnet" "test_public" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = element(var.subnets_cidr, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *         ROUTE TABLE : INTERNET GATEWAY
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "publicRouteTable"
  }
}

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *         ROUTE TABLE : SUBNET ASSOCIATION
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
resource "aws_route_table_association" "test" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.test_public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "ig_route" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "subnet_rt" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.test_public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
