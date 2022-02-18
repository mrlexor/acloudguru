resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-internet-gateway"
  }

  depends_on = [
    aws_vpc.main
  ]
}
