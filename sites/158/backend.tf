terraform {
  backend "s3" {
    bucket         = "tf-899159155532-k3s-158"
    key            = "tf-899159155532-k3s-158.tfstate"
    dynamodb_table = "tf-899159155532-k3s-158"
    region         = "ap-southeast-1"
    profile        = "ops_tf"
  }
}