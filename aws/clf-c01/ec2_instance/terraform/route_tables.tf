resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "publicRT"
  }

  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main
  ]
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id

  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main,
    aws_subnet.main
  ]
}
