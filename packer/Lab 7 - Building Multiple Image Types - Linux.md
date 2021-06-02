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
source "amazon-ebs" "centos" {
  ami_name      = "packer-centos-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ami_regions   = ["us-west-2"]
  source_ami_filter {
    filters = {
      name                = "CentOS Linux 7 x86_64 HVM EBS *"
      product-code        = "aw0evgkw8e5c1q413zgy5pjce"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "centos"
  tags = {
    "Name"        = "MyCentosImage"
    "Environment" = "Production"
    "OS_Version"  = "Centos 7"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Add a seperate build block for building the `centos` image using the `source.amazon-ebs.centos` source.

```hcl
build {
  name = "centos"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo yum -y update",
      "sudo yum install -y epel-release",
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
> packer build aws-linux.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash

amazon-ebs.ubuntu: output will be in this color.
centos.amazon-ebs.centos: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: my-ubuntu-20210513182940
==> centos.amazon-ebs.centos: Prevalidating any provided VPC information
==> centos.amazon-ebs.centos: Prevalidating AMI Name: packer-centos-aws-1620930580
    amazon-ebs.ubuntu: Found Image ID: ami-0ee02acd56a52998e
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_609d7014-8b83-6e71-7598-8e59c15dc2ee
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_609d7016-f3d1-e50d-4f59-6b134dac59a5
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"

...

Build 'amazon-ebs.ubuntu' finished after 8 minutes 38 seconds.
==> centos.amazon-ebs.centos: Adding tags to AMI (ami-05490eb55f2bc5e1b)...
==> centos.amazon-ebs.centos: Tagging snapshot: snap-0a942ea9093613d2d
==> centos.amazon-ebs.centos: Creating AMI tags
    centos.amazon-ebs.centos: Adding tag: "Environment": "Production"
    centos.amazon-ebs.centos: Adding tag: "Name": "MyCentosImage"
    centos.amazon-ebs.centos: Adding tag: "OS_Version": "Centos 7"
    centos.amazon-ebs.centos: Adding tag: "Release": "Latest"
    centos.amazon-ebs.centos: Adding tag: "Created-by": "Packer"
==> centos.amazon-ebs.centos: Creating snapshot tags
==> centos.amazon-ebs.centos: Terminating the source AWS instance...
==> centos.amazon-ebs.centos: Cleaning up any extra volumes...
==> centos.amazon-ebs.centos: Destroying volume (vol-018cf1112438487e6)...
==> centos.amazon-ebs.centos: Deleting temporary security group...
==> centos.amazon-ebs.centos: Deleting temporary keypair...
==> centos.amazon-ebs.centos: Running post-processor:  (type manifest)
Build 'centos.amazon-ebs.centos' finished after 12 minutes 54 seconds.

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
