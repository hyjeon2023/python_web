resource "aws_internet_gateway" "hy_igw" {
  vpc_id = aws_vpc.hy_vpc.id

  tags = {
    Name = "hy_igw"
  }
}

resource "aws_route_table" "hy_public_rt" {
  vpc_id = aws_vpc.hy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hy_igw.id
  }

  tags = {
    Name = "hy_public_rt"
  }
}

resource "aws_route_table_association" "hy_public_assoc" {
  subnet_id      = aws_subnet.hy_subnet.id
  route_table_id = aws_route_table.hy_public_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  
  tags = {
    Name = "hy_nat_gateway_eip"
  }
}

# NAT Gateway (Private subnet이 인터넷에 접근하기 위해 필요)
resource "aws_nat_gateway" "hy_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.hy_subnet.id  # Public subnet에 배치

  tags = {
    Name = "hy_nat_gateway"
  }

  depends_on = [aws_internet_gateway.hy_igw]
}

# Private Route Table
resource "aws_route_table" "hy_private_rt" {
  vpc_id = aws_vpc.hy_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hy_nat_gateway.id
  }

  tags = {
    Name = "hy_private_rt"
  }
}

# Private Subnet과 Route Table 연결
resource "aws_route_table_association" "hy_private_assoc" {
  subnet_id      = aws_subnet.hy_private_subnet.id
  route_table_id = aws_route_table.hy_private_rt.id
}

