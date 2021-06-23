resource "aws_lambda_function" "put" {
   function_name = "PutLambdaFunction"
   filename      = "bin/post/put.zip"
   source_code_hash = filebase64sha256("bin/post/put.zip")
   handler = "lambda_function.lambda_handler"
   runtime = "python3.8"

   role = aws_iam_role.lambda_exec.arn
}
resource "aws_iam_role" "lambda_exec" {
   name = "lambda_iam_role"

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

data "aws_iam_policy" "DynamoDBAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${data.aws_iam_policy.DynamoDBAccess.arn}"
}