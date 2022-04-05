data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = var.ami["filter"]
  }

  owners = var.ami["owners"]
}

data "aws_caller_identity" "current" {
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["benchmark-runner-BASE-v*"]
  }

  owners = [data.aws_caller_identity.current.account_id]
}
