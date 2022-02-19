resource "aws_cloudformation_stack" "network" {
  name = "MyStack"

  template_body = file("./files/acg-dynamodb-template.yaml")
}
