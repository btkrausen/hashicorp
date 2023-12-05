# Lab: HashiCorp Configuration Language

Terraform is written in HCL (HashiCorp Configuration Language) and is designed to be both human and machine
readable. HCL is built using code configuration blocks which typically follow the following syntax:

```hcl
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
 # Block body
<IDENTIFIER> = <EXPRESSION> # Argument
}

# AWS EC2 Example
resource "aws_instance" "web_server" { # BLOCK
  ami = "ami-04d29b6f966df1537" # Argument
  instance_type = var.instance_type # Argument with value as expression (Variable value replaced 11 }
```

Terraform Code Configuration block types include:
- Terraform Settings Block
- Terraform Provider Block
- Terraform Resource Block
- Terraform Data Block
- Terraform Input Variables Block
- Terraform Local Variables Block
- Terraform Output Values Block
- Terraform Modules Block

We will be utilizing Terraform Provider, Terraform Resource, Data and Input Variables Blocks in this lab. This course
will go through each of these configuration blocks in more detail throughout the course.
- Task 1: Connect to the Student Workstation
- Task 2: Verify Terraform installation
- Task 3: Update Terraform Configuration to include EC2 instance
- Task 4: Use the Terraform CLI to Get Help
- Task 5: Apply your Configuration
- Task 6: Verify EC2 Server in AWS Management Console

![AWS Application Infrastructure Buildout](img/obj-2-hcl.png)


## Task 1: Connect to the Student Workstation
In the previous lab, you learned how to connect to your workstation with either VSCode, SSH, or the web-based
client.
One you’ve connected, make sure you’ve navigated to the `/workstation/terraform` directory. This is where we’ll
do all of our work for this lab.

## Task 2: Verify Terraform installation

### Step 1.2.1

Run the following command to check the Terraform version:

```hcl
terraform -version
```

You should see:
```hcl
Terraform v1.0.8
```

## Task 3: Update Terraform Configuration to include EC2 instance

### Step 1.3.1

In the `/workstation/terraform` directory, edit the file titled `main.tf` to create an AWS EC2 instance within one of the
our public subnets.

Your final `main.tf` file should look similar to this with different values:

```hcl
provider "aws" {
  access_key = "<YOUR_ACCESSKEY>"
  secret_key = "<YOUR_SECRETKEY>"
  region = "<REGION>"
}

resource "aws_instance" "web" {
  ami = "<AMI>"
  instance_type = "t2.micro"

  subnet_id = "<SUBNET>"
  vpc_security_group_ids = ["<SECURITY_GROUP>"]

  tags = {
  "Identity" = "<IDENTITY>"
  }
}
```

Don’t forget to save the file before moving on!


## Task 4: Use the Terraform CLI to Get Help

### Step 1.4.1

Execute the following command to display available commands:

```hcl
terraform -help

Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
  The most common, useful commands are shown first, followed by
  less common or more advanced commands. If you're just getting
  started with Terraform, stick with the common commands. For the
  other commands, please read the help and docs before usage.

Common commands:
  apply    Builds or changes infrastructure
  console  Interactive console for Terraform interpolations
  destroy  Destroy Terraform-managed infrastructure
  env      Workspace management
  fmt      Rewrites config files to canonical format
  get      Download and install modules for the configuration
  graph    Create a visual graph of Terraform resources
  import   Import existing infrastructure into Terraform
  init     Initialize a Terraform working directory
  output   Read an output from a state file
  plan     Generate and show an execution plan

  ...
```
(full output truncated for sake of brevity in this guide)

Or, you can use short-hand:

```hcl
terraform -h
```

### Step 1.4.2

Navigate to the Terraform directory and initialize Terraform

```hcl
cd /workstation/terraform
```

```hcl
terraform init
  Initializing provider plugins...
  ...

Terraform has been successfully initialized!
```

### Step 1.4.3
Get help on the plan command and then run it:

```hcl
terraform -h plan
```
```hcl
terraform plan
```

## Task 5: Apply your Configuration

### Step 1.5.1
Run the `terraform apply` command to generate real resources in AWS:

```hcl
terraform apply
```

You will be prompted to confirm the changes before they’re applied. Respond with `yes`.

## Task 6: Verify EC2 Server in AWS Management Console

Login to AWS Management Console -> Services -> EC2 to verify newly created EC2 instance:

![AWS EC2 Server](img/obj-2-ec2.png)

### References
[Terraform Configuration Terraform Configuration Syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration)