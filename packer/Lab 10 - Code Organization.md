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

Place the following code blocks into the respective files.

`aws.pkr.hcl`
```hcl
data "amazon-ami" "windows_2012r2" {
  filters = {
    name = "Windows_Server-2012-R2_RTM-English-64Bit-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

data "amazon-ami" "windows_2019" {
  filters = {
    name = "Windows_Server-2019-English-Full-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

source "amazon-ebs" "ubuntu_16" {
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

source "amazon-ebs" "ubuntu_20" {
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
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
  tags = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 20.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

source "amazon-ebs" "windows_2012r2" {
  ami_name       = "my-windows-2012-aws-{{timestamp}}"
  communicator   = "winrm"
  instance_type  = "t2.micro"
  region         = "us-east-1"
  source_ami     = "${data.amazon-ami.windows_2012r2.id}"
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
}
```

`azure.pkr.hcl`
```hcl
source "azure-arm" "ubuntu_16" {
  subscription_id                   = "e1f6a3f2-9d19-4e32-bcc3-1ef1517e0fa5"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"

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

source "azure-arm" "ubuntu_20" {
  subscription_id                   = "e1f6a3f2-9d19-4e32-bcc3-1ef1517e0fa5"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"

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
  vm_size  = "Standard_A2"
}

source "azure-arm" "windows_2012r2" {
  subscription_id                   = "e1f6a3f2-9d19-4e32-bcc3-1ef1517e0fa5"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-w2k12r2-azure-{{timestamp}}"

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2012-R2-Datacenter"

  communicator     = "winrm"
  winrm_use_ssl    = true
  winrm_insecure   = true
  winrm_timeout    = "5m"
  winrm_username   = "packer"
  custom_data_file = "./scripts/SetUpWinRM.ps1"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Windows 2012R2"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_A2"
}

source "azure-arm" "windows_2019" {
  subscription_id                   = "e1f6a3f2-9d19-4e32-bcc3-1ef1517e0fa5"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-w2k19-azure-{{timestamp}}"

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
  vm_size  = "Standard_A2"
}
```

`linux-build.pkr.hcl`
```hcl
build {
  name        = "ubuntu"
  description = <<EOF
This build creates ubuntu images for ubuntu versions :
* 16.04
* 20.04
For the following builers :
* amazon-ebs
* azure-arm
EOF
  sources = [
    "source.amazon-ebs.ubuntu_16",
    "source.amazon-ebs.ubuntu_20",
    "source.azure-arm.ubuntu_16",
    "source.azure-arm.ubuntu_20",
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
* Windows 2012R2
* Windows 2019
For the following builers :
* amazon-ebs
* azure-arm
EOF
  sources = [
    "source.amazon-ebs.windows_2012r2",
    "source.amazon-ebs.windows_2019",
    "source.azure-arm.windows_2012r2",
    "source.azure-arm.windows_2019"
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

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
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

### Step 10.3.1
Run a `packer build` across all files within the `cloud_images` 

```shell
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
