# Lab: Debugging Terraform

- Task 1: Enable Logging
- Task 2: Set Logging Path
- Task 3: Disable Logging

## Task 1: Enable Logging

Terraform has detailed logs which can be enabled by setting the TF_LOG environment variable to any value. This will cause detailed logs to appear on stderr.

You can set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs, with TRACE being the most verbose.

Linux

```bash
export TF_LOG=TRACE
```

PowerShell

```shell
$env:TF_LOG="TRACE"
```

Run Terraform Apply.

```shell
terraform apply
```

Example Output

```shell
2020/03/20 13:14:41 [INFO] backend/local: apply calling Apply
2020/03/20 13:14:41 [INFO] terraform: building graph: GraphTypeApply
2020/03/20 13:14:41 [TRACE] Executing graph transform *terraform.ConfigTransformer
2020/03/20 13:14:41 [TRACE] ConfigTransformer: Starting for path:
2020/03/20 13:14:41 [TRACE] Completed graph transform *terraform.ConfigTransformer with new graph:
  data.vsphere_compute_cluster.cluster (prepare state) - *terraform.NodeApplyableResource
  data.vsphere_datacenter.dc (prepare state) - *terraform.NodeApplyableResource
  data.vsphere_datastore.datastore (prepare state) - *terraform.NodeApplyableResource
  data.vsphere_network.network (prepare state) - *terraform.NodeApplyableResource
  data.vsphere_virtual_machine.windows_template (prepare state) - *terraform.NodeApplyableResource
  vsphere_tag.tag_release (prepare state) - *terraform.NodeApplyableResource
  vsphere_tag.tag_tier (prepare state) - *terraform.NodeApplyableResource
  vsphere_tag_category.category (prepare state) - *terraform.NodeApplyableResource
  vsphere_virtual_machine.windows_vm (prepare state) - *terraform.NodeApplyableResource
  ------
2020/03/20 13:14:41 [TRACE] Executing graph transform *terraform.DiffTransformer
```

## Task 2: Enable Logging Path

To persist logged output you can set TF_LOG_PATH in order to force the log to always be appended to a specific file when logging is enabled. Note that even when TF_LOG_PATH is set, TF_LOG must be set in order for any logging to be enabled.

```bash
export TF_LOG_PATH="terraform_log.txt"
```

PowerShell

```shell
$env:TF_LOG_PATH="terraform_log.txt"
```

Run terraform init to see the initialization debugging information.

```shell
terraform init -upgrade
```

Open the `terraform_log.txt` to see the contents of the debug trace for your terraform init. Experiment with removing the provider stanza within your Terraform configuration and run a `terraform plan` to debug how Terraform searches for where a provider is located.

## Task 3: Disable Logging

Terraform logging can be disabled by clearing the appropriate environment variable.

Linux

```bash
export TF_LOG=""
```

PowerShell

```shell
$env:TF_LOG=""
```
