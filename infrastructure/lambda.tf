resource "aws_iam_role" "iam_for_lambda2" {
  name               = "iam_for_lambda2"
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


data "archive_file" "zip_nodejs" {
  type        = "zip"
  source_dir  = "../build"
  output_path = "../deploy/lambda-deploy.zip"
}
resource "aws_lambda_function" "lambda_function" {
  filename      = "../deploy/lambda-deploy.zip"
  function_name = "lambda-deploy-demo-lambda"
  description   = "My awesome lambda function"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.iam_for_lambda2.arn
  memory_size   = 128
  tags = {
    Name = "demo-lambda"
  }
}


resource "aws_iam_role_policy" "log_policy" {
  name = "log_policy"
  role = aws_iam_role.iam_for_lambda2.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/*"
          ]
        }
      ]
    }
  )
}
