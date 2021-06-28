# Lab 2: Packer CLI
The Packer command line interface (CLI) is how users/applications interact with Packer.  There is no UI or API for Packer.

Duration: 15 minutes

- Task 1: Explore the Packer CLI
- Task 2: Packer Version
- Task 3: Enable autocompletion for Packer CLI
- Task 4: Explore Subcommands and Flags
- Task 5: Packer fmt

### Task 1: Use the Terraform CLI to Get Help

Execute the following command to display available commands:

```bash
packer -help
```

```bash
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build           build image(s) from template
    console         creates a console for testing variable interpolation
    fix             fixes templates from old versions of packer
    fmt             Rewrites HCL2 config files to canonical format
    hcl2_upgrade    transform a JSON template into an HCL2 configuration
    init            Install missing plugins or upgrade plugins
    inspect         see components of a template
    validate        check that a template is valid
    version         Prints the Packer version
```

Or, you can use short-hand:

```shell
packer -h
```

### Task 2: Packer Version
Run the following command to check the Packer version:

```shell
packer -version
```

You should see:

```bash
packer -version
1.7.2
```

These labs will be building Packer configuration using HCL.  Your Packer version must be newer then 1.7.0 to utilize the HCL configuration.  If your version is older than 1.7.0, please reinstall Packer with a newer version.

### Task 3: Enable autocompletion for Packer CLI
The packer command features opt-in subcommand autocompletion that you can enable for your shell with `packer -autocomplete-install`. After doing so, you can invoke a new shell and use the feature.

```bash
packer -autocomplete-install
```

If autocompletion was already turned on, this command will indicate that it is already installed.

### Task 4: Explore Subcommands and Flags
Like many other command-line tools, the packer tool takes a subcommand to execute, and that subcommand may have additional options as well. Subcommands are executed with packer SUBCOMMAND, where "SUBCOMMAND" is the actual command you wish to execute.

You can run any packer command with the -h flag to output more detailed help for a specific subcommand.

```bash
packer validate -h
```

```bash
Usage: packer validate [options] TEMPLATE

  Checks the template is valid by parsing the template and also
  checking the configuration with the various builders, provisioners, etc.

  If it is not valid, the errors will be shown and the command will exit
  with a non-zero exit status. If it is valid, it will exit with a zero
  exit status.

Options:

  -syntax-only           Only check syntax. Do not verify config of the template.
  -except=foo,bar,baz    Validate all builds other than these.
  -machine-readable      Produce machine-readable output.
  -only=foo,bar,baz      Validate only these builds.
  -var 'key=value'       Variable for templates, can be used multiple times.
  -var-file=path         JSON or HCL2 file containing user variables.
```

```bash
packer validate aws-ubuntu.pkr.hcl
```

### Task 5: Packer fmt
The `packer fmt` Packer command is used to format HCL2 configuration files to a canonical format and style. JSON files (.json) are not modified.  `packer fmt` will display the name of the configuration file(s) that need formatting, and write any formatted changes back to the original configuration file(s).

```bash
packer fmt -diff aws-ubuntu.pkr.hcl
```

If there were formatted changes as a result of running the `packer fmt` command, those changes will be highlighted when specifiying the `-diff` flag.

```
aws-ubuntu.pkr.hcl
--- old/aws-ubuntu.pkr.hcl
+++ new/aws-ubuntu.pkr.hcl
@@ -6,9 +6,9 @@
     filters = {
       name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
       root-device-type    = "ebs"
-    virtualization-type = "hvm"
+      virtualization-type = "hvm"
     }
-        most_recent = true
+    most_recent = true
     owners      = ["099720109477"]
   }
   ssh_username = "ubuntu"
```

### Task 5: Packer Inspect
The `packer inspect` command shows all components of a Packer template including variables, builds, sources, provisioners and post-processsors.

```bash
packer inspect aws-ubuntu.pkr.hcl
```

```bash
Packer Inspect: HCL2 mode

> input-variables:


> local-variables:


> builds:

  > <unnamed build 0>:

    sources:

      amazon-ebs.ubuntu

    provisioners:

      <no provisioner>

    post-processors:

      <no post-processor>
```

Notice that there are not any variables, provisioners or post-processors in our configuration at this time.  We will be adding those items in future labs.
