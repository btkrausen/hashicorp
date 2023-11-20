# Lab: Auto Formatting Terraform Code

Terraform provides a useful subcommand that can be used to easily format all of your code. This subcommand is called `fmt`. The subcommand allows you to easily format your Terraform code to a canonical format and style based on a subset of Terraform language style conventions.

## Task 1: Format misaligned Terraform Code

Observe the code below, with the incorrect spacing and misaligned equals signs. Although this code is technically valid, it looks messy. Instead of manually fixing this, you can use a `fmt` to fix it. Update the following resource block in your `main.tf` file:

`main.tf`

```hcl
resource "random_string" "random"    {
  length = 10
  special = true
min_numeric = 6
      min_special = 2
min_upper = 3
}
```

To fix it, run the fmt subcommand as shown below:

```bash
terraform fmt
```

Looking at the same `main.tf` file now, you will see the fmt subcommand aligned the equal signs!

```hcl
resource "random_string" "random" {
  length           = 10
  special          = true
  min_numeric      = 6
  min_special      = 2
  min_upper        = 3
}
```

The `terraform fmt` command is very useful to use before checking code into version control, and many will include it as a `pre-commit` hook before checking their code into a version control system.
