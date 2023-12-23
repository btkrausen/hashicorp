# Lab: Code Organization
Packer HCL Templates can be specified in a single `file.pkr.hcl` or in multiple files within a single folder.  To assist with code readability it may be beneficial to break out a large `pkr.hcl` file into separate files.

Duration: 30 minutes

- Task 1: Breakout Packer Template across multiple files
- Task 2: Validate the Packer Template
- Task 3: Build Image accross multiple template files within a folder.
- Task 4: Target a build for a particular build type or cloud target

### Task 1: Update Packer Template across multiple files
Packer supports breaking out its template blocks across multiple files.

### Step 10.1.1

Create a `cloud_images` folder and create the following files in this folder:

- aws.pkr.hcl
- azure.pkr.hcl
- linux-build.pkr.hcl
- windows-build.prk.hcl
- variables.pkr.hcl
- example.auto.pkrvars.hcl

Place the following code blocks into the respective files.

`aws.pkr.hcl`
```hcl
data "amazon-ami" "windows_2019" {
  filters = {
    name = "Windows_Server-2019-English-Full-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

data "amazon-ami" "windows_2022" {
  filters = {
    name = "Windows_Server-2022-English-Full-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

source "amazon-ebs" "ubuntu_20" {
  ami_name      = "${var.ami_prefix}-ubuntu-20-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags         = var.tags
}

source "amazon-ebs" "ubuntu_22" {
  ami_name      = "${var.ami_prefix}-ubuntu-22-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags         = var.tags
}


source "amazon-ebs" "amazon_linux" {
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

source "amazon-ebs" "windows_2019" {
  ami_name       = "my-windows-2019-aws-{{timestamp}}"
  communicator   = "winrm"
  instance_type  = "t2.micro"
  region         = "us-east-1"
  source_ami     = "${data.amazon-ami.windows_2019.id}"
  user_data_file = "./scripts/SetUpWinRM.ps1"
  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "Administrator"
  tags = {
    "Name"        = "MyWindowsImage"
    "Environment" = "Production"
    "OS_Version"  = "Windows"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

source "amazon-ebs" "windows_2022" {
  ami_name       = "my-windows-2022-aws-{{timestamp}}"
  communicator   = "winrm"
  instance_type  = "t2.micro"
  region         = "us-east-1"
  source_ami     = "${data.amazon-ami.windows_2022.id}"
  user_data_file = "./scripts/SetUpWinRM.ps1"
  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "Administrator"
}
```

`azure.pkr.hcl`
```hcl
source "azure-arm" "ubuntu_20" {
  subscription_id                   = var.azure_subscription_id
  tenant_id                         = var.azure_tenant_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-${local.timestamp}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_sku       = "20_04-lts"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Ubuntu 20.04"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_D2s_v3"
}

source "azure-arm" "ubuntu_22" {
  subscription_id                   = var.azure_subscription_id
  tenant_id                         = var.azure_tenant_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-${local.timestamp}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Ubuntu 22.04"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_D2s_v3"
}

source "azure-arm" "windows_2019" {
  subscription_id                   = var.azure_subscription_id
  tenant_id                         = var.azure_tenant_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-w2k19-azure-${local.timestamp}"

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2019-Datacenter"

  communicator     = "winrm"
  winrm_use_ssl    = true
  winrm_insecure   = true
  winrm_timeout    = "5m"
  winrm_username   = "packer"
  custom_data_file = "./scripts/SetUpWinRM.ps1"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Windows 2019"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_D2s_v3"
}

source "azure-arm" "windows_2022" {
  subscription_id                   = var.azure_subscription_id
  tenant_id                         = var.azure_tenant_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-w2k22-azure-${local.timestamp}"

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-Datacenter"

  communicator     = "winrm"
  winrm_use_ssl    = true
  winrm_insecure   = true
  winrm_timeout    = "5m"
  winrm_username   = "packer"
  custom_data_file = "./scripts/SetUpWinRM.ps1"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Windows 2022"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_D2s_v3"
}
```

`linux-build.pkr.hcl`
```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

build {
  name        = "ubuntu"
  description = <<EOF
This build creates ubuntu images for ubuntu versions :
* 20.04
* 22.04
For the following builers :
* amazon-ebs
* azure-arm
EOF
  sources = [
    "source.amazon-ebs.ubuntu_20",
    "source.amazon-ebs.ubuntu_22",
    "source.azure-arm.ubuntu_20",
    "source.azure-arm.ubuntu_22",
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
  }

  provisioner "shell" {
    only   = ["source.amazon-ebs.ubuntu*"]
    inline = ["sudo apt-get install awscli"]
  }

  provisioner "shell" {
    only   = ["source.azure-arm.ubuntu*"]
    inline = ["sudo apt-get install azure-cli"]
  }

  post-processor "manifest" {}

}
```

`windows-build.pkr.hcl`
```hcl
build {
  name        = "windows"
  description = <<EOF
This build creates Windows images:
* Windows 2019
* Windows 2022
For the following builers :
* amazon-ebs
* azure-arm
EOF
  sources = [
    "source.amazon-ebs.windows_2019",
    "source.amazon-ebs.windows_2022",
    "source.azure-arm.windows_2019",
    "source.azure-arm.windows_2022"
  ]

  post-processor "manifest" {
  }
}
```

`variables.pkr.hcl`
```hcl
variable "ami_prefix" {
  type    = string
  default = "my-ubuntu"
}

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
  default = ["us-west-2"]
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tentant ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client ID"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
```

`example.auto.pkrvars.hcl`
```hcl
ami_prefix             = "my-ubuntu-var"
azure_subscription_id  = "<your Azure subscription key>"
azure_tenant_id        = "<your Azure tenant key>"
azure_client_id        = "<your Azure client id>"
azure_client_secret    = "<your Azure client secret>"
```

### Step 10.1.1
Create a `scripts` sub-directory and create a `SetupWinRM.ps1` file that will be used to bootstrap WinRM for an Windows images.

`SetUpWinRM.ps1`
```powershell
<powershell>

write-output "Running User Data Script"
write-host "(host) Running User Data Script"

Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# Don't set this before Set-ExecutionPolicy as it throws an error
$ErrorActionPreference = "stop"

# Remove HTTP listener
Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "packer"
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

# WinRM
write-output "Setting up WinRM"
write-host "(host) setting up WinRM"

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
cmd.exe /c winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="1024"}'
cmd.exe /c winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/client/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{CredSSP="true"}'
cmd.exe /c winrm set "winrm/config/listener?Address=*+Transport=HTTPS" "@{Port=`"5986`";Hostname=`"packer`";CertificateThumbprint=`"$($Cert.Thumbprint)`"}"
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd.exe /c netsh firewall add portopening TCP 5986 "Port 5986"
cmd.exe /c net stop winrm
cmd.exe /c sc config winrm start= auto
cmd.exe /c net start winrm

</powershell>
```

### Task 2: Validate the Packer Template
Now that the source and build blocks have been organized by cloud target and build type, we can format and validate the Packer templates across the entire directory.

### Step 10.2.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.  This time we will peform the command across all files within the `ubuntu_image` folder.

```shell
cd cloud_images
packer fmt .
packer validate .
```

### Task 3: Build a new Image using Packer
The `packer build` command can be run against all template files in a given folder.

Before initiatiating the image build be sure your cloud credentials are set.  Here is an example of setting these credentials using environment variables.

> Note: Example using environment variables on a Linux or macOS:
```bash
# AWS Credentials
export AWS_ACCESS_KEY_ID=<your access key>
export AWS_SECRET_ACCESS_KEY=<your secret key>
export AWS_DEFAULT_REGION=us-west-2

# Azure Credentials
export ARM_SUBSCRIPTION_ID=<your subscription key>
export ARM_TENANT_ID=<your tenant key>
export ARM_CLIENT_ID=<your client id>
export ARM_CLIENT_SECRET=<your client secret>
```

> Note: Example via Powershell:

```pwsh
# AWS Credentials
PS C:\> $Env:AWS_ACCESS_KEY_ID="<your access key>"
PS C:\> $Env:AWS_SECRET_ACCESS_KEY="<your secret key>"
PS C:\> $Env:AWS_DEFAULT_REGION="us-west-2"

# Azure Credentials
PS C:\> $Env:ARM_SUBSCRIPTION_ID=<your subscription key>
PS C:\> $Env:ARM_TENANT_ID=<your tenant key>
PS C:\> $Env:ARM_CLIENT_ID=<your client id>
PS C:\> $Env:ARM_CLIENT_SECRET=<your client secret>
```

> Note: Based on your the access of your Azure credentials you may need to create a Azure Resource Group to save your Packer Images

```bash
az group create -l eastus -n packer_images
```

### Step 10.3.1
Initialize and Run a `packer build` across all files within the `cloud_images` 

```shell
packer init .
packer build .
```

Packer will perform a build by aggregating the contents of all template files within a folder.

### Task 4: Target a build for a particular build type or cloud target
Targets can be specified to only run for certain cloud targets.  In this example we will only perform a run for the Amazon builders within our directory of template files.

```shell
packer build -only "*.amazon*" .
```

Targets can also be specified for certain OS types based on their source.  To build only `ubuntu 20` machines regardless of cloud

```shell
packer build -only "*.ubuntu_20" .
```
