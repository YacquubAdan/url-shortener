terraform {
  backend "s3" {
    bucket       = "yacquub-urlshortener-backend"
    key          = "terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
