resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet"
  }

  depends_on = [
    aws_vpc.main
  ]
}
