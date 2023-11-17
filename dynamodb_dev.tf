resource "aws_dynamodb_table" "liked_items_ddb_dev" {
  name         = "LIKED_ITEMS_DEV"
  billing_mode = "PAY_PER_REQUEST"
  # Both PartitionKey & SortKey makes up a PrimaryKey in DynamoDB  
  # PartitionKey
  hash_key = "AppName"
  # SortKey 
  range_key = "ItemId"

  # According to docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#dynamodb-table-attributes
  # we must add attributes for both Partition Key and Sort Key to give in their types.
  attribute {
    name = "AppName"
    type = "S"
  }

  attribute {
    name = "ItemId"
    type = "N"
  }

}

resource "aws_dynamodb_table_item" "liked_items_ddb_init_item_dev" {
  table_name = aws_dynamodb_table.liked_items_ddb_dev.name
  hash_key   = aws_dynamodb_table.liked_items_ddb_dev.hash_key
  range_key  = aws_dynamodb_table.liked_items_ddb_dev.range_key
  item       = <<ITEM
  {
    "AppName": {"S": "JS30"},
    "ItemId": {"N": "0"},
    "LikeCounter": {"N": "0"},
    "Comment": {"S": "init item"}
  }
  ITEM
}

resource "aws_dynamodb_table" "users_liked_items_ddb_dev" {
  name         = "USERS_LIKED_ITEMS_DEV"
  billing_mode = "PAY_PER_REQUEST"
  # Both PartitionKey & SortKey makes up a PrimaryKey in DynamoDB  
  # PartitionKey
  hash_key = "UserId"
  # SortKey 
  range_key = "AppName"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "AppName"
    type = "S"
  }

}

# NS stands for Number Set. It is not feasible to set the inital attribute value as NS, so it's created by inserting the item.
# Passing an empty array is bound to fail due to dynamodb's nature, also passing [""] may genereate an unexpected behaviour. 
# 

resource "aws_dynamodb_table_item" "users_liked_items_init_item_dev" {
  table_name = aws_dynamodb_table.users_liked_items_ddb_dev.name
  hash_key   = aws_dynamodb_table.users_liked_items_ddb_dev.hash_key
  range_key  = aws_dynamodb_table.users_liked_items_ddb_dev.range_key

  item = <<ITEM
{
  "UserId": {"S": "init_user"},
  "AppName": {"S": "JS30"},
  "LikedItems": {"NS":["0"]},
  "Comment":{"S":"init item"}
}
  ITEM  
}

#########################################################################################################################
# WARNING! WARNING! WARNING!
#
# Be careful with lifecycle! We need "ingore changes = item" to avoid resetting all counters to zero.
#
# WARNING! WARNING! WARNING!
#########################################################################################################################
resource "aws_dynamodb_table_item" "js30_liked_items_dev_init_setup" {
  lifecycle {
    ignore_changes = [item]
  }
  # for_each   = local.tf_data
  count      = var.number_of_likeable_items
  table_name = aws_dynamodb_table.liked_items_ddb_dev.name
  hash_key   = aws_dynamodb_table.liked_items_ddb_dev.hash_key
  range_key  = aws_dynamodb_table.liked_items_ddb_dev.range_key
  item       = templatefile("init_js30_counter_setup.tftpl", { ItemId = count.index + 1 })

  # item = jsonencode(each.value)
}

# locals {
#   json_data = file("./liked_items_init_data.json")
#   tf_data   = jsondecode(local.json_data)
# }
