# Lab: Building Images in Multiple Clouds
This lab will walk you through updating your Packer Template to build images across AWS and Azure.

Duration: 30 minutes

- Task 1: Update Packer Template to support Multiple Clouds
- Task 2: Specify Cloud Specific Attributes
- Task 2: Validate the Packer Template
- Task 3: Build Image across AWS and Azure

### Task 1: Update Packer Template to support Multiple Regions
Packer supports seperate builders for deploying images accross clouds while allowing for a single build workflow.

### Step 1.1.1

Update your `aws-linux.pkr.hcl` file with the following Packer `source` block for specifying an `azure-arm` image source.  This source contains the details for building this image in Azure.  We will keep the `aws-ebs` source untouched.  You will need to specify your own Azure credentials in the `client_id`, `client_secret`, `subscription_id` and `tenant_id`.

```hcl
source "azure-arm" "ubuntu" {
  client_id                         = "XXXX"
  client_secret                     = "XXXX"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"
  subscription_id                   = "XXXX"
  tenant_id                         = "XXXX"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "16.04-LTS"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Ubuntu 16.04"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_A2"
}
```

### Task 2: Specify Cloud Specific Attributes
The packer `build` block will need to be updated to specify both an AWS and Azure build.  This can be done with the updated `build` block:

```hcl
build {
  name = "ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu",
    "source.azure-arm.ubuntu", 
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }

  provisioner "shell" {
    only = ["source.amazon-ebs.ubuntu"]
    inline = ["sudo apt-get install awscli"]
  }

  provisioner "shell" {
    only = ["source.azure-arm.ubuntu"]
    inline = ["sudo apt-get install azure-cli"]
  }

  post-processor "manifest" {}

}
```

### Task 3: Rename and Validate the Packer Template
Now that the Packer template has been updated to be multi-cloud aware, we are going to rename the template to `linux.pkr.hcl`.  After refactoring and renaming our Packer template, we can auto format and validate the templatet via the Packer command line.

### Step 3.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt linux.pkr.hcl 
packer validate linux.pkr.hcl
```

### Task 4: Build a new Image using Packer
The `packer build` command is used to initiate the image build process across AWS and Azure.

### Step 4.1.1
Run a `packer build` for the `linux.pkr.hcl` template only for the Ubuntu build images.

```shell
packer build -only 'ubuntu*' linux.pkr.hcl
```

Packer will print output similar to what is shown below.  You should notice a different color for each cloud in which an image is being created.

```bash
packer build linux.pkr.hcl
amazon-ebs.ubuntu: output will be in this color.
azure-arm.ubuntu: output will be in this color.

==> azure-arm.ubuntu: Running builder ...
==> azure-arm.ubuntu: Getting tokens using client secret
==> azure-arm.ubuntu: Getting tokens using client secret
==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-1620188684

...
...

==> Wait completed after 8 minutes 36 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-06cb993373624ec00
us-east-1: ami-0c80e78a667406d87
us-west-2: ami-0dd51ccb6faf2588d

--> azure-arm.ubuntu: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: packer_images
ManagedImageName: myPackerImage
ManagedImageId: /subscriptions/e1f6a3f2-9d19-4e32-bcc3-1ef1517e0fa5/resourceGroups/packer_images/providers/Microsoft.Compute/images/myPackerImage
ManagedImageLocation: East US
```

##### Resources
* Packer [Docs](https://www.packer.io/docs/index.html)
* Packer [CLI](https://www.packer.io/docs/commands/index.html)
