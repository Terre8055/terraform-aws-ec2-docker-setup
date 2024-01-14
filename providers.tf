provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      "owner" = "michael.appiah.dankwah"
      "bootcamp" = "ghana2"
      "expiration_date" = "03-03-2024"
    }
  }
}