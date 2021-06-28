# Lab: Building Images for Different Operating Systems
This lab will walk you through updating your Packer Template to build different images for each operating system.

Duration: 15 minutes

- Task 1: Update Packer Template to support multiple operating system builds
- Task 2: Validate the Packer Template
- Task 3: Build Images for different operating systems

### Task 1: Update Packer Template to support Multiple Operating Systems
The Packer AWS builder supports the ability to create an AMI for multiple operating systems.  The source AMIs are specific to the operating sysetm being deployed, so we will need to specify a unique source for each unique operating system image.

### Step 1.1.1

Create a packer file named `aws-windows.pkr.hcl` file with the following Packer `source` block.

```hcl

data "amazon-ami" "windows_2012r2" {
  filters = {
    name = "Windows_Server-2012-R2_RTM-English-64Bit-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


source "amazon-ebs" "windows-2012r2" {
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

build {
  sources = ["source.amazon-ebs.windows-2012r2"]

  post-processor "manifest" {
  }
}
}
```

### Step 1.2.1

Create a `scripts` subfolder and create the following Powershell script:

- `SetUpWinRM.ps1`

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

### Step 2.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt aws-linux.pkr.hcl 
packer validate aws-linux.pkr.hcl
```

### Task 3: Build a new Image using Packer
The `packer build` command is used to initiate the image build process for a given Packer template.

### Step 3.1.1
Run a `packer build` for the `aws-windows.pkr.hcl` template.

```shell
> packer build aws-windows.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash
amazon-ebs.windows: output will be in this color.

==> amazon-ebs.windows: Prevalidating any provided VPC information
==> amazon-ebs.windows: Prevalidating AMI Name: my-windows-aws-1621167537
    amazon-ebs.windows: Found Image ID: ami-0ce14a8ecbae3e30e
==> amazon-ebs.windows: Creating temporary keypair: packer_60a10db1-94bd-d7ca-91af-b9271f7eaec1
==> amazon-ebs.windows: Creating temporary security group for this instance: packer_60a10db3-9b8d-398c-2896-5aa3087446c7
==> amazon-ebs.windows: Authorizing access to port 5986 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.windows: Launching a source AWS instance...
==> amazon-ebs.windows: Adding tags to source instance
    amazon-ebs.windows: Adding tag: "Name": "Packer Builder"
    amazon-ebs.windows: Instance ID: i-06a5f3ba437819154
==> amazon-ebs.windows: Waiting for instance (i-06a5f3ba437819154) to become ready...
==> amazon-ebs.windows: Waiting for auto-generated password for instance...
    amazon-ebs.windows: It is normal for this process to take up to 15 minutes,
    amazon-ebs.windows: but it usually takes around 5. Please wait.
    amazon-ebs.windows:  
    amazon-ebs.windows: Password retrieved!
==> amazon-ebs.windows: Using winrm communicator to connect: 3.208.31.209
==> amazon-ebs.windows: Waiting for WinRM to become available...
    amazon-ebs.windows: WinRM connected.
==> amazon-ebs.windows: Connected to WinRM!
==> amazon-ebs.windows: Provisioning with Powershell...
==> amazon-ebs.windows: Provisioning with powershell script: ./scripts/EC2Config.ps1
==> amazon-ebs.windows: Provisioning with powershell script: ./scripts/BundleConfig.ps1
==> amazon-ebs.windows: Stopping the source instance...
    amazon-ebs.windows: Stopping instance
==> amazon-ebs.windows: Waiting for the instance to stop...
==> amazon-ebs.windows: Creating AMI my-windows-aws-1621167537 from instance i-06a5f3ba437819154
    amazon-ebs.windows: AMI: ami-0a4ae96c9bf70156b
==> amazon-ebs.windows: Waiting for AMI to become ready...
==> amazon-ebs.windows: Terminating the source AWS instance...
==> amazon-ebs.windows: Cleaning up any extra volumes...
==> amazon-ebs.windows: No volumes to clean up, skipping
==> amazon-ebs.windows: Deleting temporary security group...
==> amazon-ebs.windows: Deleting temporary keypair...
==> amazon-ebs.windows: Running post-processor:  (type manifest)
Build 'amazon-ebs.windows' finished after 4 minutes 4 seconds.

==> Wait completed after 4 minutes 4 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.windows: AMIs were created:
us-east-1: ami-0a4ae96c9bf70156b

--> amazon-ebs.windows: AMIs were created:
us-east-1: ami-0a4ae96c9bf70156b
```


### Task 4: Add a Windows 2019 Image for the build
If we wanted to add additional Windows versions, we can simply create another `data` and `source` block for the additional Windows version.

### Step 3.1.1
Update our Packer template to account for adding a Windows 2019 Image

```hcl
data "amazon-ami" "windows_2019" {
  filters = {
    name = "Windows_Server-2019-English-Full-Base-*"
  }
  most_recent = true
  owners      = ["801119661308"]
  region      = "us-east-1"
}

source "amazon-ebs" "windows-2019" {
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

Update our `build` block to build both Windows versions.

```hcl
build {
  sources = ["source.amazon-ebs.windows-2012r2", "source.amazon-ebs.windows-2019", ]

  post-processor "manifest" {
  }
}
```

Invoke a packer build to build multiple Windows Images
```shell
packer fmt aws-windows.pkr.hcl
packer build aws-windows.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash
➜  packer build aws-windows.pkr.hcl
amazon-ebs.windows_2012r2: output will be in this color.
amazon-ebs.windows_2019: output will be in this color.

==> amazon-ebs.windows_2019: Prevalidating any provided VPC information
==> amazon-ebs.windows_2019: Prevalidating AMI Name: my-windows-aws-1621169911
==> amazon-ebs.windows_2012r2: Prevalidating any provided VPC information
==> amazon-ebs.windows_2012r2: Prevalidating AMI Name: my-windows-aws-1621169911
    amazon-ebs.windows_2012r2: Found Image ID: ami-0ce14a8ecbae3e30e

...

==> amazon-ebs.windows_2012r2: Deleting temporary security group...
==> amazon-ebs.windows_2012r2: Deleting temporary keypair...
==> amazon-ebs.windows_2012r2: Running post-processor:  (type manifest)
Build 'amazon-ebs.windows_2012r2' finished after 3 minutes 55 seconds.
==> amazon-ebs.windows_2019: Terminating the source AWS instance...
==> amazon-ebs.windows_2019: Cleaning up any extra volumes...
==> amazon-ebs.windows_2019: No volumes to clean up, skipping
==> amazon-ebs.windows_2019: Deleting temporary security group...
==> amazon-ebs.windows_2019: Deleting temporary keypair...
==> amazon-ebs.windows_2019: Running post-processor:  (type manifest)
Build 'amazon-ebs.windows_2019' finished after 5 minutes 1 second.

==> Wait completed after 5 minutes 1 second

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.windows_2019: AMIs were created:
us-east-1: ami-05678cc2d5115cc39

--> amazon-ebs.windows_2019: AMIs were created:
us-east-1: ami-05678cc2d5115cc39
```
