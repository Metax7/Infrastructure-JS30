resource "aws_lambda_layer_version" "x-ray_for_node" {
  filename                 = data.archive_file.archive_x-ray_layer.output_path
  layer_name               = "x-ray-for-node"
  compatible_architectures = [var.lambda_arch]
  compatible_runtimes      = [var.node_runtime]
  source_code_hash         = data.archive_file.archive_x-ray_layer.output_base64sha256
  skip_destroy             = false // true should make aws increment layer version instead of replacing. Additional charges may occure!

}

data "archive_file" "archive_x-ray_layer" {
  type        = "zip"
  source_dir  = "${path.module}/${local.lambda_layers_dir}/node/x-ray"
  output_path = "${path.module}/${var.zip_dir}/${local.lambda_layers_dir}/node/x-ray.zip"

}

resource "aws_lambda_layer_version" "axios_for_node" {
  filename                 = data.archive_file.archive_axios_for_node.output_path
  layer_name               = "nodejs_layer_dev"
  compatible_architectures = [var.lambda_arch]
  compatible_runtimes      = [var.node_runtime]
  source_code_hash         = data.archive_file.archive_axios_for_node.output_base64sha256
  skip_destroy             = false // true should make aws increment layer version instead of replacing. Additional charges may occure!

}

data "archive_file" "archive_axios_for_node" {
  //depends_on  = [null_resource.build_cognitolayer]
  type        = "zip"
  source_dir  = "${path.module}/${local.lambda_layers_dir}/node/axios"
  output_path = "${path.module}/${var.zip_dir}/${local.lambda_layers_dir}/node/axios.zip"
}

#resource "null_resource" "build_cognitolayer" {
#  # triggers = {
#  #   build_number = "${timestamp()}"
#  # }
#
#  provisioner "local-exec" {
#    command     = "sh buildlayer.sh"
#    working_dir = "${path.module}/${local.trigger_dir_name}"
#
#  }
#}



locals {
  lambda_layers_dir = "lambda-layer"
}
