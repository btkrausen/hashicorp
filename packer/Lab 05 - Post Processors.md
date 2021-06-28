# Lab: Packer Post Processors
This lab will walk you through adding a post-processor to your Packer HCL Template.  Post-processors run after the image is built by the builder and provisioned by the provisioner(s). Post-processors are optional, and they can be used to upload artifacts, re-package, or more.

Duration: 30 minutes

- Task 1: Add a Packer post-processor to write a manifest of all artifacts packer produced.
- Task 2: Validate the Packer Template
- Task 3: Build a new Image using Packer and display artifact list as a manifest

### Task 1: Add a Packer post-processor to write a manifest of all artifacts packer produced
The manifest post-processor writes a JSON file with a list of all of the artifacts packer produces during a run. If your packer template includes multiple builds, this helps you keep track of which output artifacts (files, AMI IDs, docker containers, etc.) correspond to each build.

### Step 1.1.1

Update the `build` block of your `aws-ubuntu.pkr.hcl` file with the following Packer `post-processor` block.

```hcl
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }

  post-processor "manifest" {}

}
```

### Task 2: Validate the Packer Template
Packer templates can be auto formatted and validated via the Packer command line.

### Step 2.1.1

Format and validate your configuration using the `packer fmt` and `packer validate` commands.

```shell
packer fmt aws-ubuntu.pkr.hcl 
packer validate aws-ubuntu.pkr.hcl
```

### Task 3: Build a new Image using Packer
The `packer build` command is used to initiate the image build process for a given Packer template.

### Step 3.1.1
Run a `packer build` for the `aws-ubuntu.pkr.hcl` template.

```shell
packer build aws-ubuntu.pkr.hcl
```

Packer will create a `manifest` file listing all of the image artifacts it has built

```bash
ls -la
```

This will return a list of files inside your working directory.  Validate that a `packer-manifest.json` file was created.
```bash
...

-rw-r--r--   1 gabe  staff   419 May  5 07:47 packer-manifest.json

...
```

View the `packer-manifest.json` for the details of the items that were built. 
```bash
cat packer-manifest.json
```

```bash 
{
  "builds": [
    {
      "name": "ubuntu",
      "builder_type": "amazon-ebs",
      "build_time": 1620215246,
      "files": null,
      "artifact_id": "eu-central-1:ami-0b70b458400c49bb3,us-east-1:ami-00c645bf39a7a66c2,us-west-2:ami-03b71c51298c1dc68",
      "packer_run_uuid": "136c7fbe-248e-d454-3f7a-ea39c873792e",
      "custom_data": null
    }
  ],
  "last_run_uuid": "136c7fbe-248e-d454-3f7a-ea39c873792e"
}%  
```
