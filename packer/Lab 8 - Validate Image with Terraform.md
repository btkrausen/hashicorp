# Lab: Validate Image by Using Terraform
This lab will walk you through validating our Packer image is ready for production deployment.  We will utlize HashiCorp Terraform to provision a server using the image that Packer created, and valdiate the application is accessible via the IP Address and DNS name.

Duration: 20 minutes

- Task 1: Build a new Image using Packer with our web application installed
- Task 2: Validate the Image by deploying a server using HashiCorp Terraform
- Task 3: Delete unused infrastructure after the validation is a success.

### Task 1: Build a new Image using Packer with our web application installed
This was completed in a previous lab.

### Task 2: Validate the Image by deploying a server using HashiCorp Terraform
HashiCorp Terraform is an infrastructure as code tool that excels at infrastructure provisioning and deployments.  Much like Packer, Terraform utilzes configuration files for declaring the provisioning of resources.

We will utilize Terraform to deploy a server in AWS using the private image we created with Packer.  This will allow us to validate our image works correctly when using it as a base for deploying servers in our cloud accounts.

#### Step 2.1.1
Create a `main.tf` for deploying our new image and validating the web service.  Place the following Terraform code into your `main.tf`

```hcl
variable "ami" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "test_ami" {
  ami           = var.ami
  instance_type = "t2.micro"
}

output "public_ip" {
  value = aws_instance.test_ami.public_ip
}

output "public_dns" {
  value = aws_instance.test_ami.public_dns
}
```

Perform a Terraform init, plan and apply.  Substititue in the ami that was created in during your `packer build` to deploy the image as an `EC2` instance and validate that the application is accesible at either the `public_ip` or `public_dns` address.

```bash
terraform init
terraform plan -var ami="AMI Built from Packer"
terraform apply -var ami="AMI Built from Packer"
```

```bash
output here
```

### Task 3: Delete unused infrastructure after the validation is a success.

Execute a `terraform destroy` to cleanup the `EC2` instance after the image as been validated.

```bash
terraform destroy
```