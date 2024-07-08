terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-west-2"
  }
}

module "twitter_crawler" {
  source = "../../projects/twitter_crawler"
}