terraform {
  backend "s3" {
    bucket         = ""  # override during init
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = ""
    encrypt        = true
  }
}