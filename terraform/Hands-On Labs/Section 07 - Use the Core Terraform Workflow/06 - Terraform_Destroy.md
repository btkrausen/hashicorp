# Lab: Terraform Destroy

You've now learned about all of the key features of Terraform, and how to use it to manage your infrastructure. The last command we'll use is `terraform destroy`. The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

- Task 1: Destroy your infrastructure

# Task 1: Destroy your infrastructure

The `terraform destroy` command destroys all remote objects managed by a particular Terraform configuration. It does not delete your configuration file(s), `main.tf`, etc. It destroys the resources built from your Terraform code.

Run the command `terraform destroy`:

```shell
terraform destroy
```

```shell
Plan: 0 to add, 0 to change, 39 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

```shell
...
Destroy complete! Resources: 39 destroyed.
```

You'll need to confirm the action by responding with `yes`. You could achieve the same effect by removing all of your configuration and running `terraform apply`, but you often will want to keep the configuration, but not the infrastructure created by the configuration.

You could also execute a `terraform apply` with a `-destroy` flag to achieve the same results.

```
terraform apply -destroy
```

While you will typically not want to destroy long-lived objects in a production environment, Terraform is sometimes used to manage ephemeral infrastructure for development purposes, in which case you can use terraform destroy to conveniently clean up all of those temporary objects once you are finished with your work.
