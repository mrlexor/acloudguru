resource "aws_security_group" "main" {
  name        = "my-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "my-sg"
  }

  depends_on = [
    aws_vpc.main
  ]
}
