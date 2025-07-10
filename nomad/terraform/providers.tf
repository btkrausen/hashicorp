terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  # access_key = data.vault_aws_access_credentials.rpt_demo_admin_access.access_key
  # secret_key = data.vault_aws_access_credentials.rpt_demo_admin_access.secret_key
  # token      = data.vault_aws_access_credentials.rpt_demo_admin_access.security_token
}

# provider "vault" {
#   address   = "https://rpt-demo-cluster.vault.61eeb9a4-c095-4c82-aa10-070087880f72.aws.hashicorp.cloud:8200/"
#   namespace = "admin"
#   # credentials via VAULT_TOKEN env variable
# }

# data "vault_aws_access_credentials" "rpt_demo_admin_access" {
#   backend = "aws"
#   role    = "rpt-demo-admin-access"
#   type    = "sts"
# }