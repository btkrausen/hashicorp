# Lab: Utilize Variables with Packer Templates

Duration: 35 minutes

- Task 1: Add a variable block
- Task 2: Add a local block
- Task 3: Update Packer Template to use variables
- Task 4: Build image with variables
- Task 5: Build image with a variable file
- Task 6: Build image with command line flag
- Task 7: Variablize your entire Packer configuration

### Packer Variables
Packer user variables allow your templates to be further configured with variables from the command-line, environment variables, Vault, or files. This lets you parameterize your templates so that you can keep secret tokens, environment-specific data, and other types of information out of your templates. This maximizes the portability of the template.

Variable values can be set in several ways:

- Default Values
- Inline using a `-var` parameter
- Via a variables file and specifying the `-var-file` paramater 

```bash
-var 'key=value'       Variable for templates, can be used multiple times
-var-file=path         JSON or HCL2 file containing user variables
```

### Task 1: Add a variable block
In order to set a user variable, you must define it either within the `variable` definition of your template, or using the command-line `-var` or `-var-file` flags.  Variable blocks are provided within Packer's configuration template to define variables.


Add the following variable block to your `aws-ubuntu.pkr.hcl` file.

```hcl
variable "ami_prefix" {
  type    = string
  default = "my-ubuntu"
}
```

Variable blocks declare the variable name (ami_prefix), the data type (string), and the default value (my-ubuntu). While the variable type and default values are optional, we recommend you define these attributes when creating new variables.


### Task 2: Add a local variable block

Add the following local variable block to your `aws-ubuntu.pkr.hcl` file.

```hcl
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
```

Local blocks declare the local variable name (timestamp) and the value (regex_replace(timestamp(), "[- TZ:]", "")). You can set the local value to anything, including other variables and locals. Locals are useful when you need to format commonly used values.

### Task 3: Update Packer Template to use Variables
In your Packer template, update your source block to reference the `ami_prefix` variable. Notice how the template references the variable as `var.ami_prefix`

```hcl
 ami_name      = "${var.ami_prefix}-${local.timestamp}"
```

### Task 4: Build a new Image using Packer
Format and validate your configuration using the packer fmt and packer validate commands.
```bash
packer fmt aws-ubuntu.pkr.hcl 
packer validate aws-ubuntu.pkr.hcl
```

```bash
packer build aws-ubuntu.pkr.hcl 
```

### Task 5: Build a new image with a variable file
Create a file named `example.pkrvars.hcl` and add the following snippet into it.

```hcl
ami_prefix = "my-ubuntu-var"
```

Build the image with the --var-file flag.

```bash
packer build --var-file=example.pkrvars.hcl aws-ubuntu.pkr.hcl
```


Packer will automatically load any variable file that matches the name *.auto.pkrvars.hcl, without the need to pass the file via the command line.

Rename your variable file so Packer automatically loads it.
```bash
mv example.pkrvars.hcl example.auto.pkrvars.hcl
```

```bash
packer build .
```

### Task 6: Build a new image with command line flag

```bash
packer build --var ami_prefix=my-ubuntu-var-flag .
```

### Task 7: Variablize your entire Packer configuration

Add the following variables blocks:

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_regions" {
  type    = list(string)
  default = ["us-west-2", "us-east-1", "eu-central-1"]
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 16.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Update your `source` block to utilize the variables defined

```hcl
source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags         = var.tags
}
```

Format and validate your configuration after replacing items using variables.

```bash
packer fmt aws-ubuntu.pkr.hcl 
packer validate aws-ubuntu.pkr.hcl
```
