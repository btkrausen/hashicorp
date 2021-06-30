# Lab: Integrating Packer with Ansible
The Ansible Packer provisioner runs Ansible playbooks. It dynamically creates an Ansible inventory file configured to use SSH, runs an SSH server, executes ansible-playbook , and marshals Ansible plays through the SSH server to the machine being provisioned by Packer.

Duration: 30 minutes

- Task 1: Create Packer Template for Ubuntu server customized with an Ansible playbook
- Task 2: Create Ansible Playbooks
- Task 3: Validate the Packer Template
- Task 4: Build Image
- Task 5: Set Ansible env variables via Packer

## Task 1: Create Packer Template for Ubuntu server customized with an Ansible playbook

### Step 1.1.1
Create a `aws-clumsy-bird.pkr.hcl` file:

```hcl
source "amazon-ebs" "ubuntu_20" {
  ami_name      = "${var.ami_prefix}-20-${local.timestamp}"
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

build {
  sources = [
    "source.amazon-ebs.ubuntu_20"
  ]

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_NOCOWS=1"]
    extra_arguments  = ["--extra-vars", "desktop=false", "-v"]
    playbook_file    = "${path.root}/playbooks/playbook.yml"
    user             = var.ssh_username
  }

  post-processor "manifest" {}

}
```

Create a `variables.pkr.hcl` file:
```hcl
variable "ami_prefix" {
  type    = string
  default = "my-clumsy-bird"
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
  default = ["us-east-1"]
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "ClumsyBird"
    "Environment" = "Production"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
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

## Task 2: Create Ansible Playbooks

Copy the ansible playbooks into our packer working directory

```bash
cp -R /playbooks/ /ansible/playbooks.
```

The directory structure should look as follows:

```bash

```

## Task 3: Validate the Packer Template

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt .
packer validate .
```

## Task 4: Build Image
The `packer build` command is used to initiate the image build process for a given Packer template.

```shell
packer build .
```

Packer will print output similar to what is shown below.

```bash

...


```


## Task 5: Set Ansible env variables via Packer
The `ansible_env_vars` can be updated inside the `ansible` Packer provisioner.

We will update our `ansible` provisioner block to set the `"Cow Selection"` to `random`.

```
build {
  sources = ["source.amazon-ebs.ubuntu_20"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_COW_SELECTION=random"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
    playbook_file    = "${path.root}/playbooks/playbook.yml"
    user             = var.ssh_username
  }

  post-processor "manifest" {}

}
```

```shell
packer build .
```
