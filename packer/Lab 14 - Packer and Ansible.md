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
Create a `ansible` folder with the following Packer Template called `aws-clumsy-bird.pkr.hcl` the following code:

`aws-clumsy-bird.pkr.hcl`

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
### Step 1.1.2
Create a `variables.pkr.hcl` with the following code:

`variables.pkr.hcl`

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
### Step 1.1.3
Create a `assets` sub directory with the following files inside it: `launch.sh` and `clumsy-bird.service`

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

Copy the ansible playbooks from the lab guide into our packer working directory

```bash
cp -R /playbooks/ /ansible/playbooks
```

Validate the directory structure is laid out as follows:

```bash
/ansible
.
├── assets
│   ├── clumsy-bird.service
│   └── launch.sh
├── aws-clumsy-bird.pkr.hcl
├── playbooks
│   ├── apps.yml
│   ├── base.yml
│   ├── cleanup.yml
│   ├── cloud-init.yml
│   ├── debian.yml
│   ├── playbook.yml
│   ├── redhat.yml
│   ├── virtualbox.yml
│   └── vmware.yml
└── variables.pkr.hcl
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
amazon-ebs.ubuntu_20: output will be in this color.

==> amazon-ebs.ubuntu_20: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu_20: Prevalidating AMI Name: my-clumsy-bird-20-20210630223022
    amazon-ebs.ubuntu_20: Found Image ID: ami-0dd76f917833aac4b
==> amazon-ebs.ubuntu_20: Creating temporary keypair: packer_60dcf07e-3ad9-a149-0941-c13221aad1f1
==> amazon-ebs.ubuntu_20: Creating temporary security group for this instance: packer_60dcf080-d19e-de22-d1e0-6fcb46569297
==> amazon-ebs.ubuntu_20: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu_20: Launching a source AWS instance...
==> amazon-ebs.ubuntu_20: Adding tags to source instance
    amazon-ebs.ubuntu_20: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu_20: Instance ID: i-0213b8618833c635d
==> amazon-ebs.ubuntu_20: Waiting for instance (i-0213b8618833c635d) to become ready...
==> amazon-ebs.ubuntu_20: Using ssh communicator to connect: 54.90.24.53
==> amazon-ebs.ubuntu_20: Waiting for SSH to become available...
==> amazon-ebs.ubuntu_20: Connected to SSH!
==> amazon-ebs.ubuntu_20: Uploading assets => /tmp/
==> amazon-ebs.ubuntu_20: Provisioning with Ansible...
    amazon-ebs.ubuntu_20: Setting up proxy adapter for Ansible....
==> amazon-ebs.ubuntu_20: Executing Ansible: ansible-playbook -e packer_build_name="ubuntu_20" -e packer_builder_type=amazon-ebs --ssh-extra-args '-o IdentitiesOnly=yes' --extra-vars desktop=false -v -e ansible_ssh_private_key_file=/var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/ansible-key756935621 -i /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-provisioner-ansible032233056 /Users/gabe/repos/packer_training/labs/ansible/playbooks/playbook.yml
    amazon-ebs.ubuntu_20: No config file found; using defaults
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: PLAY [default] *****************************************************************
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Gathering Facts] *********************************************************
    amazon-ebs.ubuntu_20: ok: [default]
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Debug Ansible OS Family] *************************************************
    amazon-ebs.ubuntu_20: ok: [default] => {
    amazon-ebs.ubuntu_20:     "ansible_os_family": "Debian"
    amazon-ebs.ubuntu_20: }
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Debug Packer Builder Type] ***********************************************
    amazon-ebs.ubuntu_20: ok: [default] => {
    amazon-ebs.ubuntu_20:     "packer_builder_type": "amazon-ebs"
    amazon-ebs.ubuntu_20: }
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Checking if /etc/packer_build_time Exists] *******************************
    amazon-ebs.ubuntu_20: ok: [default] => {"changed": false, "stat": {"exists": false}}
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Setting Fact - _packer_build_complete] ***********************************
    amazon-ebs.ubuntu_20: ok: [default] => {"ansible_facts": {"_packer_build_complete": false}, "changed": false}
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Debug _packer_build_complete] ********************************************
    amazon-ebs.ubuntu_20: ok: [default] => {
    amazon-ebs.ubuntu_20:     "_packer_build_complete": false
    amazon-ebs.ubuntu_20: }
    amazon-ebs.ubuntu_20:
    amazon-ebs.ubuntu_20: TASK [Base Tasks] **************************************************************

...

    amazon-ebs.ubuntu_20: PLAY RECAP *********************************************************************
    amazon-ebs.ubuntu_20: default                    : ok=41   changed=24   unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
    amazon-ebs.ubuntu_20:
==> amazon-ebs.ubuntu_20: Stopping the source instance...
    amazon-ebs.ubuntu_20: Stopping instance
==> amazon-ebs.ubuntu_20: Waiting for the instance to stop...
==> amazon-ebs.ubuntu_20: Creating AMI my-clumsy-bird-20-20210630223022 from instance i-0213b8618833c635d
    amazon-ebs.ubuntu_20: AMI: ami-0f56ee21bc688cbab
==> amazon-ebs.ubuntu_20: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu_20: Adding tags to AMI (ami-0f56ee21bc688cbab)...
==> amazon-ebs.ubuntu_20: Tagging snapshot: snap-00487425ac4014d00
==> amazon-ebs.ubuntu_20: Creating AMI tags
    amazon-ebs.ubuntu_20: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu_20: Adding tag: "Name": "ClumsyBird"
    amazon-ebs.ubuntu_20: Adding tag: "Release": "Latest"
    amazon-ebs.ubuntu_20: Adding tag: "Created-by": "Packer"
==> amazon-ebs.ubuntu_20: Creating snapshot tags
==> amazon-ebs.ubuntu_20: Terminating the source AWS instance...
==> amazon-ebs.ubuntu_20: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu_20: No volumes to clean up, skipping
==> amazon-ebs.ubuntu_20: Deleting temporary security group...
==> amazon-ebs.ubuntu_20: Deleting temporary keypair...
==> amazon-ebs.ubuntu_20: Running post-processor:  (type manifest)
Build 'amazon-ebs.ubuntu_20' finished after 6 minutes 38 seconds.

==> Wait completed after 6 minutes 38 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu_20: AMIs were created:
us-east-1: ami-0f56ee21bc688cbab
```

## Task 5: Set Ansible env variables via Packer
The `ansible_env_vars` can be updated inside the `ansible` Packer provisioner.

We will update our `ansible` provisioner block to set the `"Cow Selection"` to `random`.

```
build {
  sources = [
    "source.amazon-ebs.ubuntu_20"
  ]

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

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
