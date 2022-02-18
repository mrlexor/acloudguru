resource "aws_instance" "main" {
  ami               = data.aws_ami.main.id
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.main.id

  security_groups = [
    aws_security_group.main.id
  ]

  tags = {
    Name = "my-ec2"
  }

  depends_on = [
    aws_subnet.main
  ]
}
