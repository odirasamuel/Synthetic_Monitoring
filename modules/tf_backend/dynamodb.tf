resource "aws_dynamodb_table" "ravenc-tf-state-lock" {
  name             = "${var.stack_name}-${var.env}-tf-state-lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name             = "tf_lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {}

  attribute {
    name = "LockID"
    type = "S"
  }

  replica {
    region_name = "us-gov-east-1"
  }

  replica {
    region_name = "us-gov-west-1"
  }
}