resource "aws_iam_group" "main" {
  name = "developers"
}

resource "aws_iam_group_membership" "main" {
  count = length(data.aws_iam_users.main.names)

  name  = "tf-testing-group-membership"
  group = aws_iam_group.main.name

  users = [
    tolist(data.aws_iam_users.main.names)[count.index]
  ]

  depends_on = [
    aws_iam_group.main
  ]
}
