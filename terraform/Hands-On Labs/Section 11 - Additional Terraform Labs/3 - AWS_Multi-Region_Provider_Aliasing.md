# Lab: Terraform AWS Provider - Multi-Region and Alias

The provider `alias` allows Terraform to differentiate the two AWS providers.

- Task 1: Configure Multiple AWS Providers
- Task 2: Build Resources using provider alias

![AWS Application Infrastructure Buildout](img/aws-app-buildout.png)

## Task 1: Configure Multiple AWS Providers

```hcl
provider "aws" {
  alias   = "east"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "west"
  region  = "us-west-2"
}
```

## Task 2: Build Resources using provider alias

```hcl
data "aws_ami" "ubuntu" {
  provider = aws.east
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "example" {
  provider = aws.east
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "East Server"
  }
}

resource "aws_vpc" "west-vpc" {
  provider = aws.west
  cidr_block = "10.10.0.0/16"

  tags = {
    Name        = "west-vpc"
    Environment = "dr_environment"
    Terraform   = "true"
  }
}
```

## Reference

[Use AssumeRole to Provision AWS Resources Across Accounts](https://learn.hashicorp.com/tutorials/terraform/aws-assumerole?_ga=2.253539918.635590144.1632765411-162284920.1586109847)
