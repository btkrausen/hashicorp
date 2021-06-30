# Lab: Target Clouds and Build Types using Packer
When performing image builds it might be favorable to only target a particular build by type or cloud target.  Packer provides this ability via the `-only` and `-exclude` parameters.

Duration: 30 minutes

- Task 1: Target Provisioners to only run for certain sources
- Task 2: Target Builds for only AWS Sources
- Task 3: Target Builds for certain OS sources
- Task 4: Exclude Packer builds for specific cloud targets

We will utilize the Packer Templates from the *Code Organization* lab.

## Task 1: Target Provisioners to only run for certain sources
Targets can specified within a `provisioner` block to only run for certain image sources.  In this example we will install `azure-cli` only on the Azure Images and the `awscli` only on the AWS Images.

```hcl
  provisioner "shell" {
    only   = ["source.amazon-ebs.ubuntu*"]
    inline = ["sudo apt-get install awscli"]
  }

  provisioner "shell" {
    only   = ["source.azure-arm.ubuntu*"]
    inline = ["sudo apt-get install azure-cli"]
  }
```

## Task 2: Target Builds for only AWS Sources
Targets can be specified to only run for certain cloud targets.  In this example we will only perform a run for the Amazon builders within our directory of template files.

```
packer build -only="*.amazon*" .
```

## Task 3: Target Builds for only OS Sources

Targets can also be specified for certain OS types based on their source.  To build only `ubuntu 20` machines regardless of cloud

```shell
packer build -only "*.ubuntu_20" .
```

## Task 4: Exclude Packer builds for specific cloud targets
Just as we can target build for only certain provisoners and cloud types, we can also `except` certain builds from running by using the `-except` paramater.  In this example we will exclude all of the Ubunutu builds within our directory of template files.

```
packer build -except "ubuntu.*" .
```

##### Resources
* Packer [Only and Except](https://www.packer.io/docs/templates/hcl_templates/onlyexcept)
