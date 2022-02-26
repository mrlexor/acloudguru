resource "aws_iam_policy_attachment" "main" {
  name       = "my_dev_access"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"

  groups = [
    aws_iam_group.main.name
  ]

  depends_on = [
    aws_iam_group.main
  ]
}
