terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
  backend "s3" {
    bucket         = "gh-bc2-tfstate"
    key            = "mike-tf/doiteasy.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-mike-lock"
    encrypt        = true
  }
}


module "network" {
  source = "./modules/network"
}


module "compute" {
  source = "./modules/compute"
}