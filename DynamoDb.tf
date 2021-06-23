resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "MyDb"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "myId"

  attribute {
    name = "myId"
    type = "N"
  }
}