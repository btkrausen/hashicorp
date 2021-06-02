# Lab 0: Install Packer
Packer Packer may be installed in the following ways:

- Using a precompiled binary.
- Installing from source. (Recommended for advanced users)
- Using your system's package manager.

This lab will walk you through installing packer on an Ubuntu workstation using the `apt` package manager

Duration: 10 minutes

- Task 1: Install Packer on Ubuntu Workstation
- Task 2: Validate the Packer Install
- Task 3: Enable autocompletion for Packer CLI

### Task 1: Install Packer on Ubuntu Workstation
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
sudo cp /usr/bin/packer /usr/local/bin/packer
```

### Task 2: Validate the Packer Install
```bash
which packer
/usr/local/bin/packer
```

```bash
packer version
Packer v1.7.2
```

### Task 3: Enable autocompletion for Packer CLI
```bash
packer -autocomplete-install
```
