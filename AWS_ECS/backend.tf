terraform {
  backend "s3" {
    bucket       = "terraform-state-wbd-actor-2025"
    key          = "ecs-app/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
