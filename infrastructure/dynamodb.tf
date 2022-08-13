resource "aws_dynamodb_table" "iotdeviceslist" {
  name         = "${var.table_name}-${var.stage_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "serial_no"

  attribute {
    name = "serial_no"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = var.stage_name
  }
}


resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.bosch_iot_lambda_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["dynamodb:PutItem"],
          "Resource" : "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.table_name}-${var.stage_name}*"
        }
      ]
    }
  )
}
