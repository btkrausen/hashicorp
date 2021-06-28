# Lab: Integrating Packer with Ansible
The ansible Packer provisioner runs Ansible playbooks. It dynamically creates an Ansible inventory file configured to use SSH, runs an SSH server, executes ansible-playbook , and marshals Ansible plays through the SSH server to the machine being provisioned by Packer.

Duration: 30 minutes

- Task 1: Update Packer Template to support multiple operating system builds
- Task 2: Validate the Packer Template
- Task 3: Build Images for different operating systems

### Task 1: Create Packer Template for Ubuntu server customized with an Ansible playbook.

### Step 1.1.1
Create a `ubuntu_1804.pkr.hcl` file:

```hcl
source "amazon-ebs" "ubuntu_18" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
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
  sources = ["source.amazon-ebs.ubuntu_18"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
    playbook_file    = "${path.root}/playbooks/playbook.yml"
    user             = var.ssh_username
  }

  post-processor "manifest" {}

}
```

Create a `variables.prk.hcl` file:
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
  default = ["us-east-1"]
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
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

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
```

Copy the ansible playbooks into our packer working directory

```bash
mkdir assets
cp -R /ansible/playbooks/ .
```

```hcl
provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
    playbook_file    = "${path.root}/playbooks/playbook.yml"
    user             = "${var.ssh_username}"
  }
```

### Step 2.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt ubuntu_1804.pkr.hcl
packer validate ubuntu_1804.pkr.hcl
```

### Task 3: Build a new Image using Packer
The `packer build` command is used to initiate the image build process for a given Packer template.

### Step 3.1.1
Run a `packer build` for the `ubuntu_1804.pkr.hcl` template.

```shell
packer build ubuntu_1804.pkr.hcl
```

Packer will print output similar to what is shown below.

```bash

...


```


### Task 4: Set Ansible env variables via Packer
The `ansible_env_vars` can be updated inside the `ansible` Packer provisioner.

We will update our `ansible` provisioner block to set the `"Cow Selection"` to `random`.

```
build {
  sources = ["source.amazon-ebs.ubuntu_18"]

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
packer build ubuntu_1804.pkr.hcl
```