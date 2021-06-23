resource "aws_api_gateway_rest_api" "my_api" {
  name = "my_api"
}

# Resource
resource "aws_api_gateway_resource" "post_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.my_api.id}"
  parent_id = "${aws_api_gateway_rest_api.my_api.root_resource_id}"
  path_part = "insert"
}

# Method
resource "aws_api_gateway_method" "post_method" {
  rest_api_id = "${aws_api_gateway_rest_api.my_api.id}"
  resource_id = "${aws_api_gateway_resource.post_resource.id}"
  http_method = "POST"
  authorization = "NONE"
}

# Integration
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.my_api.id}"
  resource_id = "${aws_api_gateway_resource.post_resource.id}"
  http_method = "${aws_api_gateway_method.post_method.http_method}"
  uri = aws_lambda_function.put.invoke_arn
  type = "AWS"                           
  integration_http_method = "POST"       
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.post_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.post_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  depends_on = [
    aws_api_gateway_integration.post_integration
  ]
}

resource "aws_api_gateway_resource" "get_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.get_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.my_api.id}"
  resource_id = "${aws_api_gateway_resource.get_resource.id}"
  http_method = "${aws_api_gateway_method.get_method.http_method}"
  uri = aws_lambda_function.get.invoke_arn
  type = "AWS_PROXY"                           
  integration_http_method = "POST"       
}

resource "aws_lambda_permission" "apigw_get_lambda" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_get_200" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}


resource "aws_api_gateway_deployment" "deploy_api" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  depends_on = [
    aws_api_gateway_integration.post_integration,
    aws_api_gateway_integration.get_integration
  ]
}

resource "aws_api_gateway_stage" "stage_1" {
  deployment_id = aws_api_gateway_deployment.deploy_api.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "stage1"
}

resource "aws_api_gateway_integration_response" "get_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.response_get_200.status_code
  depends_on = [
    aws_api_gateway_integration.get_integration
  ]
}
