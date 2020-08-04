resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-ecs-jenkins-007"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

