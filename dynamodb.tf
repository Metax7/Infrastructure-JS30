resource "aws_dynamodb_table" "liked_items_ddb_prod" {
  name         = "LIKED_ITEMS_PROD"
  billing_mode = "PAY_PER_REQUEST"
  # Both PartitionKey & SortKey makes up a PrimaryKey in DynamoDB  
  # PartitionKey
  hash_key = "AppName"
  # SortKey 
  range_key = "ItemId"

  attribute {
    name = "LikeCounter"
    type = "N"
  }

}

resource "aws_dynamodb_table" "users_liked_items_ddb_prod" {
  name         = "USERS_LIKED_ITEMS_PROD"
  billing_mode = "PAY_PER_REQUEST"
  # Both PartitionKey & SortKey makes up a PrimaryKey in DynamoDB  
  # PartitionKey
  hash_key = "UserId"
  # SortKey 
  range_key = "AppName"

  # NS stands for Number Set
  attribute {
    name = "LikedItems"
    type = "NS"
  }
}

resource "aws_dynamodb_table_item" "liked_items" {

  # for_each   = local.tf_data
  count      = var.number_of_likeable_items
  table_name = aws_dynamodb_table.liked_items_ddb_prod.name
  hash_key   = aws_dynamodb_table.liked_items_ddb_prod.hash_key
  range_key  = aws_dynamodb_table.liked_items_ddb_prod.range_key
  item       = jsonencode(templatefile("ddb_js30_liked_items_init.tftpl", { ItemId = count.index }))

  # item = jsonencode(each.value)
}

# locals {
#   json_data = file("./liked_items_init_data.json")
#   tf_data   = jsondecode(local.json_data)
# }

