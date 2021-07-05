# Lab: Integrating Packer with Terraform
HashiCorp Terraform is a simple and powerful tool for safely and predictably creating, changing, and improving infrastructure.  Terraform is an infrastructure as code (IaC) tool that uses declarative configuration files written in HashiCorp Configuration Language (HCL) similar to Packer.  While Packer excels at building automated machine images, Terraform excels at deploying those images which is why Packer and Terraform are typically found to be complementary for infrastructure as code lifecycles.

Duration: 30 minutes

- Task 1: Create Terraform code for deploying Packer Images into AWS
- Task 2: Deploy instance from AMI using Terraform
- Task 3: Validate application deployment
- Task 4: Update the Terraform Code to always pull the latest Packer machine image

This lab assumes that you have [Terraform](https://www.terraform.io/downloads.html) locally installed on your workstation and that you have completed the Packer and Ansible Lab succesfully.

## Task 1: Create Terraform code for deploying Packer Images
Create a `packer_terraform` folder with the following Terraform configuration file called `main.tf`

`main.tf`
```hcl
variable "ami" {
  type = string
  description = "Application Image to Deploy"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "appname" {
  type    = string
  description = "Application Name"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "test_ami" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = "MyEC2Instance"

  tags = {
    "Name" = var.appname
  }
}

output "public_ip" {
  value = aws_instance.test_ami.public_ip
}

output "public_dns" {
  value = aws_instance.test_ami.public_dns
}

output "clumsy_bird" {
  value = "http://${aws_instance.test_ami.public_dns}:8001"
}
```

This Terraform configuration will deploy an AWS EC2 instance built from any AWS machine image.  We will be specifying the Packer AMI built in a previous lab.

## Task 2: Execute Terraform and specify AMI image created by Packer

### Step 2.1.1
Authenticate to AWS by specifying an ACCESS and SECRET ACCESS Keys

```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

### Step 2.1.2
Initialize Terraform and run a plan.

```bash
terraform init
terraform plan
```

When prompted for the AMI id, utlize an AMI that was created in the Packer and Ansible Lab.  This ID will be located in the `manifest.json` file generated from the `packer build` from this lab.

```
terraform plan
var.ami
  Application Image to Deploy

  Enter a value: ami-0f56ee21bc688cbab

var.appname
  Application Name

  Enter a value: Clumsy Bird
```

View the `plan` details for the Terraform deployment.

```bash
var.ami
  Application Image to Deploy

  Enter a value: ami-0f56ee21bc688cbab

var.appname
  Application Name

  Enter a value: Clumsy Bird


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.test_ami will be created
  + resource "aws_instance" "test_ami" {
      + ami                                  = "ami-0f56ee21bc688cbab"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "MyEC2Instance"
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "Clumsy Bird"
        }
      + tags_all                             = {
          + "Name" = "Clumsy Bird"
        }
      + tenancy                              = (known after apply)
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + clumsy_bird = (known after apply)
  + public_dns  = (known after apply)
  + public_ip   = (known after apply)
```

### Step 2.1.3
Deploy the Packer AMI image as an instance via a `terraform apply`.

```bash
terraform apply
```

When prompted for the AMI id, utlize an AMI that was created in the Packer and Ansible Lab.  This ID will be located in the `manifest.json` file generated from the `packer build` from this lab.

```bash
terraform apply

var.ami
  Application Image to Deploy

  Enter a value: ami-0f56ee21bc688cbab

var.appname
  Application Name

  Enter a value: Clumsy Bird
```

Validate the plan and enter `yes` to provision the instance.
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

## Task 3: Validate application deployment
Now that the instance has been deployed, the application can be validate by browsing to the `clumsy_bird` url from the terraform output.

Enjoy the game play.

![Clumsy Bird](img/clumsy_bird.png)

When you are complete with the game issue a `terraform destroy` to clean up the server.  This will reduce the cost of your AWS spend.

```bash
terraform destroy
```

## Task 4: Update the Terraform Code to always pull the latest Packer machine image

Now that we have succesfully deployed our application via Packer and Terraform, we are going to modify our Terraform code to always pull the latest machine image Packer creates.  This will allow Terraform to lookup our AMI without needing to prompt for an input.

Update our `main.tf` by adding:

- a `data` block to lookup the ami image id
- updating the instance resource to point the `ami` to our data lookup of the Packer image.
- remove the `ami` variable from our terraform configuration

```hcl
data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name   = "tag:Created-by"
    values = ["Packer"]
  }

  filter {
    name   = "tag:Name"
    values = [var.appname]
  }

  owners = ["self"]
}
```

```hcl
resource "aws_instance" "test_ami" {
  ami           = data.aws_ami.packer_image.image_id
  instance_type = "t2.micro"
  key_name      = "MyEC2Instance"

  tags = {
    "Name" = var.appname
  }
}
```

Remove the `ami` variable from our Terraform code.

```hcl
variable "ami" {
  type = string
  description = "Application Image to Deploy"
}
```

Execute a `terraform plan` and `terraform apply`

```bash
terraform plan -var 'appname=ClumsyBird' 
terraform apply -var 'appname=ClumsyBird' 
```

Now that the instance has been deployed, the application can be validate by browsing to the `clumsy_bird` url from the terraform output.

Enjoy the game play.

![Clumsy Bird](img/clumsy_bird.png)

When you are complete with the game issue a `terraform destroy` to clean up the server. 
