variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_ACCESS_KEY" {
  default = "AKIAXME5E5TEQWAA43UG"
}

variable "AWS_SECRET_KEY" {
  default = "AnV1+3hz+2tVzWvEYZIXW5iWqeqf3v6OHlhvQE3e"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}


variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-1924770e"
    us-west-2 = "ami-56ed4936"
    eu-west-1 = "ami-c8337dbb"
  }
}

# Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
