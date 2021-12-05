# Lab: Packer Breakpoints
The breakpoint provisioner will pause until the user presses "enter" to resume the build. This is intended for debugging purposes, and allows you to halt at a particular part of the provisioning process. This is independent of the -debug flag, which will instead halt at every step and between every provisioner.

Breakpoints are especially useful for troubleshooting items within a provisoner as it leaves the Virtual Machine running before erroring or creating an image.

- Task 1: Use a Breakpoint Provisioner
- Task 2: Use a Breakpoint Provisioner with Packer Debugging
- Task 3: Validate Build Provisioners with Packer Debug & Breakpoints 

## Task 1: Using a Breakpoint Provisioner

Create a `packer-breakpoints.pkr.hcl` Packer Template

```hcl
source "null" "debug" {
  communicator = "none"
}

build {
  sources = ["source.null.debug"]

  provisioner "shell-local" {
    inline = ["echo hi"]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "this is a breakpoint"
  }

  provisioner "shell-local" {
    inline = ["echo hi 2"]
  }

}
```

### Execute a Packer Build

```bash
packer build packer-breakpoints.pkr.hcl
```

The build should run straight through to completion; you should see output that
reads

```bash
Breakpoint provisioner with note "this is a breakpoint" disabled; continuing...
```

Open up the `packer-breakpoints.pkr.hcl` file and change `disable = false` from the
breakpont provisioner definition.

Run `packer build packer-breakpoints.pkr.hcl` again. This time you'll see the output

>==> null: Pausing at breakpoint provisioner with note "this is a breakpoint".
>==> null: Press enter to continue.

The build will remain paused until you press enter to continue it, allowing
you all the time you need to navigate to investigate your build environment.

## Task 2: Use a Breakpoint Provisioner with Packer Debugging
Now that we have a better understanding of some of the troubleshooting items available to us with Packer, let's combine Packer debugging along with the breakpoint provisioners to validate a few of our provisioners.

Create a `aws-clumsy-bird.pkr.hcl` Packer Template.  This template will be Ubuntu based running in AWS.  The template contains several provisioners, including `breakpoints` before and after key parts of the build process.

```hcl
source "amazon-ebs" "ubuntu" {
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
    "Name"        = "Clumsy Bird"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 20.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Testing"
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "inspect before installing nginx"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get install -y nginx"
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "validate after installing nginx"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

  provisioner "breakpoint" {
    disable = false
    note    = "validate files are uploaded"
  }

  post-processor "manifest" {}

}
```

Create a `assets` folder with the following files inside it: `launch.sh` and `clumsy-bird.service`

`launch.sh`

```bash
#!/bin/bash
grunt connect
```

`clumsy-bird.service`

```bash
[Install]
WantedBy=multi-user.target

[Unit]
Description=Clumsy Bird App

[Service]
WorkingDirectory=/src/clumsy-bird
ExecStart=/src/clumsy-bird/launch.sh >> /var/log/webapp.log
IgnoreSIGPIPE=false
KillMode=process
Restart=on-failure
```

## Task 3: Validate Build Provisioners with Packer Debug & Breakpoints 

Execute a `packer build` for the clumsy-bird image with debugging enabled.

```bash
packer build -debug aws-clumsy-bird.pkr.hcl
```

SSH into the image and validate that the files have been uploaded as you step through the debug commands.

```bash
ssh -i PACKER.PEM ubuntu@IP_ADDRESS
```

Example:

```
ssh -i ec2_ubuntu.pem ubuntu@54.149.137.240
```

Once connect to the image, run a series of checks on the `nginx` service and the files in the `/tmp` directory.

```bash
sudo systemctl status nginx
ls -ll /tmp
```

Depending on when you execute the commands (before/after the breakpoint) should see the service enabled and files present.

```bash
==> amazon-ebs.ubuntu: Pausing at breakpoint provisioner with note "inspect before installing nginx".
==> amazon-ebs.ubuntu: Press enter to continue. 

...

==> amazon-ebs.ubuntu: Pausing at breakpoint provisioner with note "validate after installing nginx".
==> amazon-ebs.ubuntu: Press enter to continue.

...

==> amazon-ebs.ubuntu: Uploading assets => /tmp/
==> amazon-ebs.ubuntu: Pausing at breakpoint provisioner with note "validate files are uploaded".
==> amazon-ebs.ubuntu: Press enter to continue. 
```
