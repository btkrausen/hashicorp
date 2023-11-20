# Lab: Generate SSH Key with Terraform TLS Provider

The Terraform TLS provider provides utilities for working with Transport Layer Security keys and certificates. It provides resources that allow private keys, certificates and certificate requests to be created as part of a Terraform deployment.

- Task 1: Check Terraform
- Task 2: Install Terraform TLS Provider
- Task 3: Creates a self-signed certificate with TLS Provider

## Task 1: Check Terraform version

Run the following command to check the Terraform version:

```shell
terraform -version
```

You should see:

```text
Terraform v1.0.10
```

## Task 2: Install Terraform TLS Provider

Edit the file titled `terraform.tf` to add the Terraform TLS provider.

`terraform.tf`

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}
```

Install the provider by performing a `terraform init`

```bash
terraform init
```

This informs Terraform that it will install the TLS provider for working with Transport Layer Security keys and certificates.

Validate the installation by running a `terraform version`

```bash
terraform version
```

```
Terraform v1.0.10
on linux_amd64
+ provider registry.terraform.io/hashicorp/aws v3.62.0
+ provider registry.terraform.io/hashicorp/http v2.1.0
+ provider registry.terraform.io/hashicorp/local v2.1.0
+ provider registry.terraform.io/hashicorp/random v3.1.0
+ provider registry.terraform.io/hashicorp/tls v3.1.0
```

## Task 3: Creates a self-signed certificate with TLS Provider

Update the `main.tf` file with the followig configuration blocks for generating a TLS self signed certificate and saving the private key locally.

```hcl
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}
```

> Note: This example creates a self-signed certificate for a development environment. THIS IS NOT RECOMMENDED FOR PRODUCTION SERVICES.

Create the Keypair via Terraform

```bash
terraform apply
```

```bash
Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Validate you now have a self-signed private key inside your current working directory name `MyAWSKey.pem`

```bash
ls -la

-rwxr-xr-x 1 student student MyAWSKey.pem

cat MyAWSKey.pem

-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAv7Y/09hkhorQUPEdsmWSej62NoTucPvZCyaKqtKs/UnGM31A
Q2w7yQ2VPuEUP1SPJsk0CgJFRHdLQ/uUFWJAtTTE0iV2sOKL77mMZKZREsmG3wT0
m5Xh3uT8SPhkLFOwgQfPjVdCKFNs8Qip4S6sktWgtw0mV/SioDNYZArNhV+viye0
wa/jXu55H/C1d4HcaALb9+UcruT0M5Kqo1Xjgt6gGDpQjidK0Qsdjyaoz8JKQMbK
fZV3DWC9RJ+Sm94gqt9QbiJgnCVlP8IWEcyMBA6P99RSjNB/geH/H4Jvoeg7W1B1
56/s1vZ4G0XzydlyLY7v5j0vyRumAqq5boCv3QIDAQABAoIBAFv4QoaOuSsSTP2H
rod20t5yV1ewTfNF3snKo5tvli2sxrjMzZeKxOOe8IpJ0DzRhBtHSv/CNxixYhor
Bs97Yy+LMSDfeCFDjX5jtUZTw3EP3PQAnJhHPyR/Fcir4OKjA3njFV7pDYPrAchg
L58nlQKcGY23cT2gzqOr/iuAQzhH6SRoNvu+DXvKPGWIpWxSPhhSHMHeO8N3spLJ
4DptEf0hJ/IiBIJpXoaNO9sYVBoRUfD4g3SapqP0cwVK27R/Zy1FcOujuqzeE/Ot
Rxk80aVSa+50F4SnY7LAGtdME3D39d6c4FpVGXKAoOp1tFpswAQDubib64YKDSNU
0/fMLMECgYEAxVtJwK4v7BCNqNLW9cR5A/LLTFGgVpBNP9BIyVOaCrx9rjezC7ny
Q+2I3/dMAPI9+kuchktzPfsTjUEGM01Iu6HLQjZDECOVC4tUyjA41I1Unz2E2t3u
bWxQN5bDVPLX14VH4Gt/8Ku1WLu+u79jmaByT6jHA3S2iNkrQBrr1M8CgYEA+K2T
eIniHzjRsx7PZmrMDN/qIi6VC6zUfwSaoQxmrEQ0FlQixNumfjnJ3/wBWvsL1f89
5xG1m7Ro4WA+0dQHr3POHCY/JiAIVN7CBVjAUGUa/RjkuDsSujFrGx0UOEgM0RZe
k7uW4BjNiVSpO0v7bZXPY23hOsZYMLmzqB/b85MCgYB22+npP37hH38RhBmuXqu7
cwh5aFe2iqXbnueXSOBnQuo2eJk+oLiFrJNYv6lokHw/ODaGsv4u//3gfp7rWspJ
JsIxmFh/ac6j60AfnTc82/lxBi3zWuHzyN3u/L+bc74GsOB/Cn89RUysqjXPAQ9N
QNJXo4BoVmxwsspXi18pBQKBgC9QLw+vBDO2hsdSpFkzFpGYhJ5uSHNJNcDY6mab
ymkaLOLWrSrRM7MuYYdZFhTuUMktX+S3zNrMD2xZ+HnJopCyMtPOPxOM4qjrHPUR
dr2VDvZ6pwGaU6zTPDKTbMZshuu9Gs920HTgozJuxif/A95Ms4GSZVjeZecXXeQt
85Y7AoGBALUqqStHLKYwFI2WRiBkHlfz2Kx/aP81F+q+ngBMQWm26eQW7TrBPdaj
QVXqbZSdF3IDYF3Wnk42QAVKqiimYCGqbZoUokWobtENrHAhtjznH4etqXQLTsJp
q9OkP3kpPogLdTClQNZ06x4tFx4M5P+GZViynodX+jZfCp0C41VB
-----END RSA PRIVATE KEY-----
```

We will use this private key in a future lab for associating with our server instances and using it for a means of authentication.
