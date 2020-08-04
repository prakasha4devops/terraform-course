terraform {
  backend "s3" {
    bucket = "terraform-state-ecs-jenkins-007"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}