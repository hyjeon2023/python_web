provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
    }
  }
}

provider "google" {
  region = "asia-northeast3"  #Seoul
}