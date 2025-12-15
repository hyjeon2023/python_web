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

