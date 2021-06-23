resource "aws_lambda_function" "get" {
   function_name = "getLambdaFunction"
   filename      = "bin/get/get.zip"
   source_code_hash = filebase64sha256("bin/get/get.zip")
   handler = "lambda_function.lambda_handler"
   runtime = "python3.8"

   role = aws_iam_role.lambda_exec.arn
}