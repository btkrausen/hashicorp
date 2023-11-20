# Lab: Terraform Plug-in Based Architecture

Terraform relies on plugins called "providers" to interact with remote systems and expand functionality. Terraform configurations must declare which providers they require so that Terraform can install and use them. This is performed within a Terraform configuration block.

- Task 1: View available Terraform Providers
- Task 2: Install the Terraform AWS Provider
- Task 3: View installed and required providers

## Task 1: View available Terraform Providers

Terraform Providers are plugins that implement resource types for particular clouds, platforms and generally speaking any remote system with an API. Terraform configurations must declare which providers they require, so that Terraform can install and use them. Popular Terraform Providers include: AWS, Azure, Google Cloud, VMware, Kubernetes and Oracle.

![Terraform Plug-in Architecture](img/terraform-plugin-ins.png)

For a full list of available Terraform providers, reference the [Terraform Provider Registry](https://registry.terraform.io/)

![Terraform Provider Registry](./img/terraform_provider_registry.png)

## Task 2: Install the Terraform AWS Provider

To install the [Terraform AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest), and set the provider version in a way that is very similar to how you did for Terraform. To begin you need to let Terraform know to use the provider through a `required_providers` block in the `terraform.tf` file as seen below.

`terraform.tf`

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
```

> Note: You can always find the latest version of a provider on its > registry page at https://registry.terraform.io.

Run a `terraform init` to install the providers specified in the configuration

```shell
terraform init
```

## Task 3: View installed and required providers

If you ever would like to know which providers are installed in your working directory and those required by the configuration, you can issue a `terraform version` and `terraform providers` command.

```shell
terraform version
```

```shell
Terraform v1.0.10
on darwin_amd64
+ provider registry.terraform.io/hashicorp/aws v3.64.2
+ provider registry.terraform.io/hashicorp/random v3.1.0
```

```shell
terraform providers
```

```shell
Providers required by configuration:
.
|-- provider[registry.terraform.io/hashicorp/aws] ~> 3.0
|-- provider[registry.terraform.io/hashicorp/random]

Providers required by state:

    provider[registry.terraform.io/hashicorp/aws]

    provider[registry.terraform.io/hashicorp/random]
```