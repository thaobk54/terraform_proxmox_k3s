terraform {
  backend "s3" {
    bucket         = "tf-899159155532-k3s"
    key            = "tf-899159155532-k3s.tfstate"
    dynamodb_table = "tf-899159155532-k3s"
    region         = "ap-southeast-1"
    profile        = "ops_tf"
  }
}