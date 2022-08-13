resource "aws_iam_role" "bosch_iot_lambda_role" {
  name               = "bosch_iot_lambda_role"
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
  source_dir  = "../dist"
  output_path = "../deploy/lambda-deploy.zip"
}
resource "aws_lambda_function" "lambda_function" {
  filename         = "../deploy/lambda-deploy.zip"
  function_name    = "bosch-iot-lambda"
  description      = "Store IOT device data"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256(data.archive_file.zip_nodejs.output_path)
  role             = aws_iam_role.bosch_iot_lambda_role.arn
  memory_size      = 128
  tags = {
    Name = "bosch_iot_lambda"
  }
}


resource "aws_iam_role_policy" "log_policy" {
  name = "log_policy"
  role = aws_iam_role.bosch_iot_lambda_role.id
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
