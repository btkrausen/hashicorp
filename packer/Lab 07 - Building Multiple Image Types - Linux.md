# Lab: Building Images for Different Operating Systems
This lab will walk you through updating your Packer Template to build different images for each operating system.

Duration: 15 minutes

- Task 1: Update Packer Template to support multiple operating system builds
- Task 2: Validate the Packer Template
- Task 3: Build Images for different operating systems

### Task 1: Update Packer Template to support Multiple Operating Systems
The Packer AWS builder supports the ability to create an AMI for multiple operating systems.  The source AMIs are specific to the operating sysetm being deployed, so we will need to specify a unique source for each unique operating system image.

### Step 1.1.1

Add the following blocks to the `aws-ubuntu.pkr.hcl` file with the following Packer `source` block.

```hcl
source "amazon-ebs" "amazon-linux" {
  ami_name      = "packer-aws-linux-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ami_regions   = ["us-west-2"]
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm*"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
  tags = {
    "Name"        = "MyAmazonLinuxImage"
    "Environment" = "Production"
    "OS_Version"  = "Amazon 2"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Add a seperate build block for building the `amazon-linux` image using the `source.amazon-ebs.amazon-linux` source.

```hcl
build {
  name = "amazon-linux"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum -y update",
      "sudo amazon-linux-extras install epel",
      "sudo yum install -y nginx"
    ]
  }

  post-processor "manifest" {}

}
```

### Task 2: Validate the Packer Template
Rename the Packer templates `aws-ubuntu.pkr.hcl` to `aws-linux.pkr.hcl`as it now supports multiple flavors of linux.  This template can be auto formatted and validated via the Packer command line.

### Step 2.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt aws-linux.pkr.hcl 
packer validate aws-linux.pkr.hcl
```

### Task 3: Build a new Image using Packer
The `packer build` command is used to initiate the image build process for a given Packer template.

### Step 3.1.1
Run a `packer build` for the `aws-linux.pkr.hcl` template.

```shell
packer build aws-linux.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash

amazon-ebs.ubuntu: output will be in this color.
centos.amazon-ebs.amazon-linux: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: my-ubuntu-20210513182940
==> amazon-linux.amazon-ebs.amazon-linux: Prevalidating any provided VPC information
==> amazon-linux.amazon-ebs.amazon-linux: Prevalidating AMI Name: packer-amazon-linux-aws-1620930580
    amazon-ebs.ubuntu: Found Image ID: ami-0ee02acd56a52998e
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_609d7014-8b83-6e71-7598-8e59c15dc2ee
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_609d7016-f3d1-e50d-4f59-6b134dac59a5
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"

...

Build 'amazon-ebs.ubuntu' finished after 8 minutes 38 seconds.
==> amazon-linux.centos.amazon-ebs.amazon-linux: Adding tags to AMI (ami-05490eb55f2bc5e1b)...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Tagging snapshot: snap-0a942ea9093613d2d
==> amazon-linux.centos.amazon-ebs.amazon-linux: Creating AMI tags
    amazon-linux.centos.amazon-ebs.amazon-linux: Adding tag: "Environment": "Production"
    amazon-linux.centos.amazon-ebs.amazon-linux: Adding tag: "Name": "MyAmazonLinuxImage"
    amazon-linux.centos.amazon-ebs.amazon-linux: Adding tag: "OS_Version": "Amazon 2"
    amazon-linux.centos.amazon-ebs.amazon-linux: Adding tag: "Release": "Latest"
    amazon-linux.centos.amazon-ebs.amazon-linux: Adding tag: "Created-by": "Packer"
==> amazon-linux.centos.amazon-ebs.amazon-linux: Creating snapshot tags
==> amazon-linux.centos.amazon-ebs.amazon-linux: Terminating the source AWS instance...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Cleaning up any extra volumes...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Destroying volume (vol-018cf1112438487e6)...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Deleting temporary security group...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Deleting temporary keypair...
==> amazon-linux.centos.amazon-ebs.amazon-linux: Running post-processor:  (type manifest)
Build 'amazon-linux.amazon-ebs.amazon-linux' finished after 12 minutes 54 seconds.

==> Wait completed after 12 minutes 54 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-0d3149a44d9d5cf0a
us-east-1: ami-0598ff452495420ec
us-west-2: ami-00c47ae1ca96cc667

--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-0d3149a44d9d5cf0a
us-east-1: ami-0598ff452495420ec
us-west-2: ami-00c47ae1ca96cc667

--> centos.amazon-ebs.centos: AMIs were created:
us-west-2: ami-05490eb55f2bc5e1b

--> centos.amazon-ebs.centos: AMIs were created:
us-west-2: ami-05490eb55f2bc5e1b
```
