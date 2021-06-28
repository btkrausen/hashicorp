# Lab: Target Clouds and Build Types using Packer
When performing image builds it might be favorable to only target a particular build by type or cloud target.  Packer provides this ability via the `-only` and `-exclude` paramaters.

Duration: 30 minutes

- Task 1: Target Provisioners to only run for certain sources
- Task 2: Target Builds for only AWS Sources
- Task 3: Exclude packer builds for certain cloud targets

## Task 1 - Target Provisioners to only run for certain sources
Targets can specified within a `provisioner` block to only run for certain image sources.  In this example we will install `git` only on the Azure Image, as the AWS image already has it installed.

```hcl
provisioner "shell-local" {
    only = ["azure-arm.ubuntu"]
    inline = ["apt-install git"]
}
```

## Task 2 - Target Builds for only AWS Sources
Targets can be specified to only run for certain cloud targets.  In this example we will only perform a run for the Amazon EBS builders within our directory of template files.

```
packer build -only '*.amazon-ebs.*' .
```

```
packer build -only="*.amazon*" linux.pkr.hcl
```

## Task 3: Exclude packer builds for certain cloud targets
Just as we can target build for only certain provisoners and cloud types, we can also `exclude` certain builds from running by using the `-exclude` paramater.  In this example we will exclude all of the Windows builds within our directory of template files.

```
packer build -exclude '' .
```

```
packer build -exclude '' .
```

##### Resources
* Packer [Only and Except](https://www.packer.io/docs/templates/hcl_templates/onlyexcept)
