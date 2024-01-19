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

locals {
  lambda_layers_dir = "lambda-layer"
}
