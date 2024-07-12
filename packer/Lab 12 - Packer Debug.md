# Lab: Debugging Packer
Often times it becomes necessary to turn on debugging when performing Packer image builds.  Packer supports several ways in which to enable and work with debugging.

- Task 1: Enable Packer Logging
- Task 2: Set Log Path
- Task 3: Disable Packer Logging
- Task 4: Enable debugging mode via Packer build
- Task 5: Inspect Failures

Duration: 20 minutes

## Task 1: Enable and Disable Packer detailed logging
Packer has detailed logs which can be enabled by setting the `PACKER_LOG` environment variable to `1`. This will cause detailed logs to appear on stderr.

Linux

```bash
export PACKER_LOG=1
```

PowerShell

```shell
$env:PACKER_LOG=1
```

Create a `debug_lab` folder with the following Packer Template called `aws-clumsy-bird.pkr.hcl` the following code base:

```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
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
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}
```

**Example Output**

```shell
cd debug_lab
packer init .
```

```shell
2023/12/20 22:51:45 [INFO] Packer version: 1.10.0 [go1.20.11 linux amd64]
2023/12/20 22:51:45 [TRACE] discovering plugins in /usr/local/bin
2023/12/20 22:51:45 [TRACE] discovering plugins in .
2023/12/20 22:51:45 [TRACE] discovering plugins in /root/.config/packer/plugins
2023/12/20 22:51:45 [INFO] Discovered potential plugin: amazon = /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64
2023/12/20 22:51:45 [INFO] Discovered potential plugin: azure = /root/.config/packer/plugins/github.com/hashicorp/azure/packer-plugin-azure_v2.0.1_x5.0_linux_amd64
2023/12/20 22:51:45 [INFO] found external [chroot ebs ebssurrogate ebsvolume instance] builders from amazon plugin
2023/12/20 22:51:45 [INFO] found external [import] post-processors from amazon plugin
2023/12/20 22:51:45 found external [ami parameterstore secretsmanager] datasource from amazon plugin
2023/12/20 22:51:45 [INFO] found external [arm chroot dtl] builders from azure plugin
2023/12/20 22:51:45 found external [dtlartifact] provisioner from azure plugin
2023/12/20 22:51:45 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/12/20 22:51:45 [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/12/20 22:51:45 [WARN] Config file doesn't exist: /root/.packerconfig
2023/12/20 22:51:45 [INFO] Setting cache directory: /root/.cache/packer
2023/12/20 22:51:45 [TRACE] init: plugingetter.ListInstallationsOptions{FromFolders:[]string{"/usr/local/bin", ".", "/root/.config/packer/plugins"}, BinaryInstallationOptions:plugingetter.BinaryInstallationOptions{APIVersionMajor:"5", APIVersionMinor:"0", OS:"linux", ARCH:"amd64", Ext:"", Checksummers:[]plugingetter.Checksummer{plugingetter.Checksummer{Type:"sha256", Hash:(*sha256.digest)(0xc000346f00)}}}}
2023/12/20 22:51:45 [TRACE] listing potential installations for "github.com/hashicorp/amazon" that match "~> 1". plugingetter.ListInstallationsOptions{FromFolders:[]string{"/usr/local/bin", ".", "/root/.config/packer/plugins"}, BinaryInstallationOptions:plugingetter.BinaryInstallationOptions{APIVersionMajor:"5", APIVersionMinor:"0", OS:"linux", ARCH:"amd64", Ext:"", Checksummers:[]plugingetter.Checksummer{plugingetter.Checksummer{Type:"sha256", Hash:(*sha256.digest)(0xc000346f00)}}}}
2023/12/20 22:51:45 [TRACE] listing potential installations for "github.com/hashicorp/azure" that match "~> 2". plugingetter.ListInstallationsOptions{FromFolders:[]string{"/usr/local/bin", ".", "/root/.config/packer/plugins"}, BinaryInstallationOptions:plugingetter.BinaryInstallationOptions{APIVersionMajor:"5", APIVersionMinor:"0", OS:"linux", ARCH:"amd64", Ext:"", Checksummers:[]plugingetter.Checksummer{plugingetter.Checksummer{Type:"sha256", Hash:(*sha256.digest)(0xc000346f00)}}}}
2023/12/20 22:51:46 [INFO] (telemetry) Finalizing.
2023/12/20 22:51:46 waiting for all plugin processes to complete...
```

```
packer validate .
```

```shell
2023/12/21 21:02:35 [INFO] Packer version: 1.10.0 [go1.20.11 linux amd64]
2023/12/21 21:02:35 [TRACE] discovering plugins in /usr/local/bin
2023/12/21 21:02:35 [TRACE] discovering plugins in .
2023/12/21 21:02:35 [TRACE] discovering plugins in /root/.config/packer/plugins
2023/12/21 21:02:35 [INFO] Discovered potential plugin: amazon = /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64
2023/12/21 21:02:35 [INFO] found external [chroot ebs ebssurrogate ebsvolume instance] builders from amazon plugin
2023/12/21 21:02:35 [INFO] found external [import] post-processors from amazon plugin
2023/12/21 21:02:35 found external [ami parameterstore secretsmanager] datasource from amazon plugin
2023/12/21 21:02:35 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/12/21 21:02:35 [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/12/21 21:02:35 [WARN] Config file doesn't exist: /root/.packerconfig
2023/12/21 21:02:35 [INFO] Setting cache directory: /root/.cache/packer
2023/12/21 21:02:35 [TRACE] listing potential installations for "github.com/hashicorp/amazon" that match "~> 1". plugingetter.ListInstallationsOptions{FromFolders:[]string{"/usr/local/bin", ".", "/root/.config/packer/plugins"}, BinaryInstallationOptions:plugingetter.BinaryInstallationOptions{APIVersionMajor:"5", APIVersionMinor:"0", OS:"linux", ARCH:"amd64", Ext:"", Checksummers:[]plugingetter.Checksummer{plugingetter.Checksummer{Type:"sha256", Hash:(*sha256.digest)(0xc000346f00)}}}}
2023/12/21 21:02:35 [TRACE] Found the following "github.com/hashicorp/amazon" installations: [{/root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 v1.2.9}]
2023/12/21 21:02:35 [INFO] found external [chroot ebs ebssurrogate ebsvolume instance] builders from amazon plugin
2023/12/21 21:02:35 [INFO] found external [import] post-processors from amazon plugin
2023/12/21 21:02:35 found external [ami parameterstore secretsmanager] datasource from amazon plugin
2023/12/21 21:02:35 [INFO] Starting external plugin /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 start builder ebs
2023/12/21 21:02:35 Starting plugin: /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 []string{"/root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64", "start", "builder", "ebs"}
2023/12/21 21:02:35 Waiting for RPC address for: /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64
2023/12/21 21:02:35 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:02:35 Plugin address: unix /tmp/packer-plugin1611511683
2023/12/21 21:02:35 Received unix RPC address for /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64: addr is /tmp/packer-plugin1611511683
2023/12/21 21:02:35 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:02:35 Waiting for connection...
2023/12/21 21:02:35 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:02:35 Serving a plugin connection...
2023/12/21 21:02:35 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:02:35 [TRACE] starting builder ebs
2023/12/21 21:02:35 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:02:35 [INFO] (aws): No AWS timeout and polling overrides have been set. Packer will default to waiter-specific delays and timeouts. If you would like to customize the length of time between retries and max number of retries you may do so by setting the environment variables AWS_POLL_DELAY_SECONDS and AWS_MAX_ATTEMPTS or the configuration options aws_polling_delay_seconds and aws_polling_max_attempts to your desired values.
The configuration is valid.
2023/12/21 21:02:35 [INFO] (telemetry) Finalizing.
2023/12/21 21:02:35 waiting for all plugin processes to complete...
2023/12/21 21:02:35 /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64: plugin process exited
```

```shell
packer build .
```

```shell
2023/12/21 21:03:05 [INFO] Packer version: 1.10.0 [go1.20.11 linux amd64]
2023/12/21 21:03:05 [TRACE] discovering plugins in /usr/local/bin
2023/12/21 21:03:05 [TRACE] discovering plugins in .
2023/12/21 21:03:05 [TRACE] discovering plugins in /root/.config/packer/plugins
2023/12/21 21:03:05 [INFO] Discovered potential plugin: amazon = /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64
2023/12/21 21:03:05 [INFO] found external [chroot ebs ebssurrogate ebsvolume instance] builders from amazon plugin
2023/12/21 21:03:05 [INFO] found external [import] post-processors from amazon plugin
2023/12/21 21:03:05 found external [ami parameterstore secretsmanager] datasource from amazon plugin
2023/12/21 21:03:05 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/12/21 21:03:05 [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/12/21 21:03:05 [WARN] Config file doesn't exist: /root/.packerconfig
2023/12/21 21:03:05 [INFO] Setting cache directory: /root/.cache/packer
2023/12/21 21:03:05 [TRACE] listing potential installations for "github.com/hashicorp/amazon" that match "~> 1". plugingetter.ListInstallationsOptions{FromFolders:[]string{"/usr/local/bin", ".", "/root/.config/packer/plugins"}, BinaryInstallationOptions:plugingetter.BinaryInstallationOptions{APIVersionMajor:"5", APIVersionMinor:"0", OS:"linux", ARCH:"amd64", Ext:"", Checksummers:[]plugingetter.Checksummer{plugingetter.Checksummer{Type:"sha256", Hash:(*sha256.digest)(0xc000348d00)}}}}
2023/12/21 21:03:06 [TRACE] Found the following "github.com/hashicorp/amazon" installations: [{/root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 v1.2.9}]
2023/12/21 21:03:06 [INFO] found external [chroot ebs ebssurrogate ebsvolume instance] builders from amazon plugin
2023/12/21 21:03:06 [INFO] found external [import] post-processors from amazon plugin
2023/12/21 21:03:06 found external [ami parameterstore secretsmanager] datasource from amazon plugin
2023/12/21 21:03:06 [INFO] Starting external plugin /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 start builder ebs
2023/12/21 21:03:06 Starting plugin: /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 []string{"/root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64", "start", "builder", "ebs"}
2023/12/21 21:03:06 Waiting for RPC address for: /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 Plugin address: unix /tmp/packer-plugin4099997961
2023/12/21 21:03:06 Received unix RPC address for /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64: addr is /tmp/packer-plugin4099997961
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 Waiting for connection...
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 Serving a plugin connection...
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 [TRACE] starting builder ebs
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 [INFO] (aws): No AWS timeout and polling overrides have been set. Packer will default to waiter-specific delays and timeouts. If you would like to customize the length of time between retries and max number of retries you may do so by setting the environment variables AWS_POLL_DELAY_SECONDS and AWS_MAX_ATTEMPTS or the configuration options aws_polling_delay_seconds and aws_polling_max_attempts to your desired values.
amazon-ebs.ubuntu: output will be in this color.

2023/12/21 21:03:06 Build debug mode: false
2023/12/21 21:03:06 Force build: false
2023/12/21 21:03:06 On error: 
2023/12/21 21:03:06 Waiting on builds to complete...
2023/12/21 21:03:06 Starting build run: amazon-ebs.ubuntu
2023/12/21 21:03:06 Running builder: 
2023/12/21 21:03:06 [INFO] (telemetry) Starting builder amazon-ebs.ubuntu
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 [INFO] AWS Auth provider used: "EnvProvider"
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 Found region us-west-2
2023/12/21 21:03:06 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:06 [INFO] AWS Auth provider used: "EnvProvider"
==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-1703192586
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:07 Using AMI Filters {
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:   Filters: [{
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Name: "root-device-type",
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Values: ["ebs"]
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:     },{
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Name: "virtualization-type",
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Values: ["hvm"]
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:     },{
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Name: "name",
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:       Values: ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:     }],
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:   IncludeDeprecated: false,
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin:   Owners: ["099720109477"]
2023/12/21 21:03:07 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: }
    amazon-ebs.ubuntu: Found Image ID: ami-008fe2fc65df48dac
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_6584a80a-4ae5-0cd6-48fe-4214dbefe9e3
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_6584a80c-80ce-b44c-b5b6-f9e106f152a1
2023/12/21 21:03:09 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:09 [DEBUG] Waiting for temporary security group: sg-02d50289bde17339e
2023/12/21 21:03:10 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:10 [DEBUG] Found security group sg-02d50289bde17339e
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
    amazon-ebs.ubuntu: Instance ID: i-0e81a511970de326f
==> amazon-ebs.ubuntu: Waiting for instance (i-0e81a511970de326f) to become ready...
2023/12/21 21:03:45 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:45 [INFO] Not using winrm communicator, skipping get password...
==> amazon-ebs.ubuntu: Using SSH communicator to connect: 54.191.216.197
2023/12/21 21:03:45 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:45 [INFO] Waiting for SSH, up to timeout: 5m0s
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
2023/12/21 21:03:45 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:45 Using host value: 54.191.216.197
2023/12/21 21:03:45 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:45 [DEBUG] TCP connection to SSH ip/port failed: dial tcp 54.191.216.197:22: connect: connection refused
2023/12/21 21:03:50 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:50 Using host value: 54.191.216.197
2023/12/21 21:03:51 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:51 [INFO] Attempting SSH connection to 54.191.216.197:22...
2023/12/21 21:03:51 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:51 [DEBUG] reconnecting to TCP connection for SSH
2023/12/21 21:03:51 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:51 [DEBUG] handshaking with SSH
2023/12/21 21:03:52 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:52 [DEBUG] handshake complete!
2023/12/21 21:03:52 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:52 [INFO] no local agent socket, will not connect agent
==> amazon-ebs.ubuntu: Connected to SSH!
2023/12/21 21:03:52 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:03:52 Running the provision hook
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws-1703192586 from instance i-0e81a511970de326f
    amazon-ebs.ubuntu: AMI: ami-0f8619b3645091ec5
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
2023/12/21 21:06:01 packer-plugin-amazon_v1.2.9_x5.0_linux_amd64 plugin: 2023/12/21 21:06:01 fast-boot disabled, no launch-template to set
==> amazon-ebs.ubuntu: Skipping Enable AMI deprecation...
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-0f8619b3645091ec5)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-00be4c8f958c53ce8
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Release": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Created-by": "Packer"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "Clumsy Bird"
    amazon-ebs.ubuntu: Adding tag: "OS_Version": "Ubuntu 22.04"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu' finished after 3 minutes 15 seconds.
2023/12/21 21:06:22 [INFO] (telemetry) ending amazon-ebs.ubuntu
==> Wait completed after 3 minutes 15 seconds
==> Builds finished. The artifacts of successful builds are:
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact-count []string{"1"}

==> Wait completed after 3 minutes 15 seconds

==> Builds finished. The artifacts of successful builds are:
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "builder-id", "mitchellh.amazonebs"}
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "id", "us-west-2:ami-0f8619b3645091ec5"}
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "string", "AMIs were created:\nus-west-2: ami-0f8619b3645091ec5\n"}
--> amazon-ebs.ubuntu: AMIs were created:
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "files-count", "0"}
2023/12/21 21:06:22 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "end"}
us-west-2: ami-0f8619b3645091ec5
us-west-2: ami-0f8619b3645091ec5

2023/12/21 21:06:22 [INFO] (telemetry) Finalizing.
2023/12/21 21:06:22 waiting for all plugin processes to complete...
2023/12/21 21:06:22 /root/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_linux_amd64: plugin process exited
```

## Task 2: Set Log Path
To persist logged output you can set PACKER_LOG_PATH in order to force the log to always be appended to a specific file when logging is enabled. Note that even when PACKER_LOG_PATH is set, PACKER_LOG must be set in order for any logging to be enabled.

```bash
export PACKER_LOG_PATH="packer_log.txt"
```

PowerShell

```shell
$env:PACKER_LOG_PATH="packer_log.txt"
```

Initiate a Packer Build

```shell
packer build .
```

Open the `packer_log.txt` to see the contents of the debug trace for your packer build.

## Task 3: Disable Packer Logging
To disable Packer detailed logging set the `PACKER_LOG=0`

Linux

```bash
export PACKER_LOG=0
export PACKER_LOG_PATH=""
```

PowerShell

```shell
$env:PACKER_LOG=0
$env:PACKER_LOG_PATH="packer_log.txt"
```

## Task 4: Enable debugging mode via Packer build
For remote builds with cloud providers like Amazon Web Services AMIs, debugging a Packer build can be eased greatly with `packer build -debug`. This disables parallelization and enables debug mode.

```shell
packer build -debug .
```

## Task 5: Inspect Failures
Packer provides the ability to inspect failures during the debug process.

`packer build -on-error=ask` allows you to inspect failures and try out solutions before restarting the build.

```shell
packer build -on-error=ask .
```

You can simulate a failure by issuing a `Ctrl+C` and Packer will prompt for how it should handle the failure condition:

```shell
==> amazon-ebs.ubuntu: Step "StepRunSourceInstance" failed
==> amazon-ebs.ubuntu: [c] Clean up and exit, [a] abort without cleanup, or [r] retry step (build may fail even if retry succeeds)?
```
