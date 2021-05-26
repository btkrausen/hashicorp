# Lab: Building Images in Multiple Regions
This lab will walk you through updating your Packer Template to build images across multiple regions within AWS.

Duration: 30 minutes

- Task 1: Update Packer Template to support Multiple Regions
- Task 2: Validate the Packer Template
- Task 3: Build Image across Multiple AWS Regions

### Task 1: Update Packer Template to support Multiple Regions
The Packer AWS builder supports the ability to create an AMI in multiple AWS regions.  AMIs are specific to regions so this will ensure that the same image is available in all regions within a single cloud.  We will also leverage Tags to indentify our image.

### Step 1.1.1

Update your `aws-ubuntu.pkr.hcl` file with the following Packer `source` block.

```hcl
source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ami_regions   = ["us-west-2", "us-east-1", "eu-central-1"]
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
  tags = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 16.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

### Task 2: Validate the Packer Template
Packer templates can be auto formatted and validated via the Packer command line.

### Step 2.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt aws-ubuntu.pkr.hcl 
packer validate aws-ubuntu.pkr.hcl
```

### Task 3: Build Image across Multiple AWS Regions
The `packer build` command is used to initiate the image build process for a given Packer template.

### Step 3.1.1
Run a `packer build` for the `aws-ubuntu.pkr.hcl` template.

```shell
packer build aws-ubuntu.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash
➜  packer build aws-ubuntu.pkr.hcl
amazon-ebs.ubuntu: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws
    amazon-ebs.ubuntu: Found Image ID: ami-0dd273d94ed0540c0
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_609212c5-c68b-dc41-0eb9-7cb972a8b9eb
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_609212c8-d327-58c7-186c-13f94c74d862
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu: Instance ID: i-0f44e7c3f7c7210fe
==> amazon-ebs.ubuntu: Waiting for instance (i-0f44e7c3f7c7210fe) to become ready...
==> amazon-ebs.ubuntu: Using ssh communicator to connect: 34.212.137.135
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
==> amazon-ebs.ubuntu: Connected to SSH!
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws from instance i-0f44e7c3f7c7210fe
    amazon-ebs.ubuntu: AMI: ami-00888c7a855bd746e
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu: Copying/Encrypting AMI (ami-00888c7a855bd746e) to other regions...
    amazon-ebs.ubuntu: Copying to: us-east-1
    amazon-ebs.ubuntu: Copying to: eu-central-1
    amazon-ebs.ubuntu: Waiting for all copies to complete...
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-00888c7a855bd746e)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-0f96df693fc7e347e
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-0c8839484fe21cabd)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-00b593cda536fd3d1
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-0050f6e5610e47950)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-0d1ab9c893da1f615
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu' finished after 8 minutes 39 seconds.

==> Wait completed after 8 minutes 39 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-0050f6e5610e47950
us-east-1: ami-0c8839484fe21cabd
us-west-2: ami-00888c7a855bd746e
```

Note that we now have created the same image in the `eu-central-1`, `us-east-1` and `us-west-2` regions.

##### Resources
* Packer [Docs](https://www.packer.io/docs/index.html)
* Packer [CLI](https://www.packer.io/docs/commands/index.html)
