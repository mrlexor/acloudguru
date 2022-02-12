provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_role" "main" {
  name = "myiam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "main" {
  function_name = "myfunction"
  role          = aws_iam_role.main.arn
  description   = "ACloudGuru lab"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename = "./handlers/lambda_function.py.zip"
}

resource "aws_lambda_invocation" "main" {
  function_name = aws_lambda_function.main.arn

  input = jsonencode({
    first_name = "Egor",
    last_name  = "Alekseev"
  })
}

data "aws_lambda_invocation" "main" {
  function_name = aws_lambda_function.main.arn

  input = jsonencode({
    first_name = "Egor",
    last_name  = "Alekseev"
  })
}

output "result" {
  value = jsondecode(data.aws_lambda_invocation.main.result)
}
