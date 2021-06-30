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
}
```

**Example Output**

```shell
packer validate .
```

```shell
2021/06/29 21:22:19 [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:22:19 [TRACE] discovering plugins in /usr/local/bin
2021/06/29 21:22:19 [TRACE] discovering plugins in /Users/gabe/.packer.d/plugins
2021/06/29 21:22:19 [TRACE] discovering plugins in .
2021/06/29 21:22:19 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:22:19 [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:22:19 [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:22:19 [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:22:19 [TRACE] Starting internal plugin packer-builder-amazon-ebs
2021/06/29 21:22:19 Starting plugin: /usr/local/bin/packer []string{"/usr/local/bin/packer", "plugin", "packer-builder-amazon-ebs"}
2021/06/29 21:22:19 Waiting for RPC address for: /usr/local/bin/packer
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: args: []string{"packer-builder-amazon-ebs"}
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: Plugin address: unix /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin369510082
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: Waiting for connection...
2021/06/29 21:22:19 Received unix RPC address for /usr/local/bin/packer: addr is /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin369510082
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: Serving a plugin connection...
2021/06/29 21:22:19 packer-builder-amazon-ebs plugin: [INFO] (aws): No AWS timeout and polling overrides have been set. Packer will default to waiter-specific delays and timeouts. If you would like to customize the length of time between retries and max number of retries you may do so by setting the environment variables AWS_POLL_DELAY_SECONDS and AWS_MAX_ATTEMPTS or the configuration options aws_polling_delay_seconds and aws_polling_max_attempts to your desired values.
2021/06/29 21:22:19 [INFO] (telemetry) Finalizing.
2021/06/29 21:22:19 waiting for all plugin processes to complete...
2021/06/29 21:22:19 /usr/local/bin/packer: plugin process exited
...
```

```shell
packer build .
```

```shell
2021/06/29 21:43:50 [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:43:50 [TRACE] discovering plugins in /usr/local/bin
2021/06/29 21:43:50 [TRACE] discovering plugins in /Users/gabe/.packer.d/plugins
2021/06/29 21:43:50 [TRACE] discovering plugins in .
2021/06/29 21:43:50 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:43:50 [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:43:50 [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:43:50 [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:43:50 [TRACE] Starting internal plugin packer-builder-amazon-ebs
2021/06/29 21:43:50 Starting plugin: /usr/local/bin/packer []string{"/usr/local/bin/packer", "plugin", "packer-builder-amazon-ebs"}
2021/06/29 21:43:50 Waiting for RPC address for: /usr/local/bin/packer
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: args: []string{"packer-builder-amazon-ebs"}
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: Plugin address: unix /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin945249578
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: Waiting for connection...
2021/06/29 21:43:50 Received unix RPC address for /usr/local/bin/packer: addr is /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin945249578
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: Serving a plugin connection...
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] (aws): No AWS timeout and polling overrides have been set. Packer will default to waiter-specific delays and timeouts. If you would like to customize the length of time between retries and max number of retries you may do so by setting the environment variables AWS_POLL_DELAY_SECONDS and AWS_MAX_ATTEMPTS or the configuration options aws_polling_delay_seconds and aws_polling_max_attempts to your desired values.
2021/06/29 21:43:50 Build debug mode: false
2021/06/29 21:43:50 Force build: false
2021/06/29 21:43:50 On error: 
2021/06/29 21:43:50 Waiting on builds to complete...
2021/06/29 21:43:50 Starting build run: amazon-ebs.ubuntu
2021/06/29 21:43:50 Running builder: 
amazon-ebs.ubuntu: output will be in this color.
2021/06/29 21:43:50 [INFO] (telemetry) Starting builder 

2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] AWS Auth provider used: "SharedCredentialsProvider"
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: Found region us-west-2
2021/06/29 21:43:50 packer-builder-amazon-ebs plugin: [INFO] AWS Auth provider used: "SharedCredentialsProvider"
==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-1625017430
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin: Using AMI Filters {
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:   Filters: [{
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Name: "name",
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Values: ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"]
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:     },{
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Name: "root-device-type",
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Values: ["ebs"]
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:     },{
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Name: "virtualization-type",
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:       Values: ["hvm"]
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:     }],
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin:   Owners: ["099720109477"]
2021/06/29 21:43:51 packer-builder-amazon-ebs plugin: }
    amazon-ebs.ubuntu: Found Image ID: ami-01773ce53581acf22
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_60dbcc56-9a5b-72c6-764e-cb30596cec44
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_60dbcc58-d42a-5fa5-a69b-8a55afdcc4ae
2021/06/29 21:43:52 packer-builder-amazon-ebs plugin: [DEBUG] Waiting for temporary security group: sg-0a176e9216c8cb269
2021/06/29 21:43:53 packer-builder-amazon-ebs plugin: [DEBUG] Found security group sg-0a176e9216c8cb269
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu: Instance ID: i-0f1905f1ea48da479
==> amazon-ebs.ubuntu: Waiting for instance (i-0f1905f1ea48da479) to become ready...
2021/06/29 21:44:42 packer-builder-amazon-ebs plugin: [INFO] Not using winrm communicator, skipping get password...
==> amazon-ebs.ubuntu: Using ssh communicator to connect: 54.201.204.154
2021/06/29 21:44:42 packer-builder-amazon-ebs plugin: [INFO] Waiting for SSH, up to timeout: 5m0s
2021/06/29 21:44:42 packer-builder-amazon-ebs plugin: Using host value: 54.201.204.154
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
2021/06/29 21:44:42 packer-builder-amazon-ebs plugin: [DEBUG] TCP connection to SSH ip/port failed: dial tcp 54.201.204.154:22: connect: connection refused
2021/06/29 21:44:47 packer-builder-amazon-ebs plugin: Using host value: 54.201.204.154
2021/06/29 21:44:47 packer-builder-amazon-ebs plugin: [INFO] Attempting SSH connection to 54.201.204.154:22...
2021/06/29 21:44:47 packer-builder-amazon-ebs plugin: [DEBUG] reconnecting to TCP connection for SSH
2021/06/29 21:44:47 packer-builder-amazon-ebs plugin: [DEBUG] handshaking with SSH
2021/06/29 21:44:48 packer-builder-amazon-ebs plugin: [DEBUG] handshake complete!
2021/06/29 21:44:48 packer-builder-amazon-ebs plugin: [DEBUG] Opening new ssh session
2021/06/29 21:44:51 packer-builder-amazon-ebs plugin: [INFO] agent forwarding enabled
==> amazon-ebs.ubuntu: Connected to SSH!
2021/06/29 21:44:51 packer-builder-amazon-ebs plugin: Running the provision hook
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws-1625017430 from instance i-0f1905f1ea48da479
    amazon-ebs.ubuntu: AMI: ami-0fb58842ec2e0b5a7
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-0fb58842ec2e0b5a7)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-0debf55b9c9812339
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "Clumsy Bird"
    amazon-ebs.ubuntu: Adding tag: "OS_Version": "Ubuntu 20.04"
    amazon-ebs.ubuntu: Adding tag: "Release": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Created-by": "Packer"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
2021/06/29 21:47:30 [INFO] (telemetry) ending 
==> Wait completed after 3 minutes 40 seconds
==> Builds finished. The artifacts of successful builds are:
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact-count []string{"1"}
Build 'amazon-ebs.ubuntu' finished after 3 minutes 40 seconds.

==> Wait completed after 3 minutes 40 seconds

==> Builds finished. The artifacts of successful builds are:
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "builder-id", "mitchellh.amazonebs"}
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "id", "us-west-2:ami-0fb58842ec2e0b5a7"}
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "string", "AMIs were created:\nus-west-2: ami-0fb58842ec2e0b5a7\n"}
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "files-count", "0"}
2021/06/29 21:47:30 machine readable: amazon-ebs.ubuntu,artifact []string{"0", "end"}
us-west-2: ami-0fb58842ec2e0b5a7
--> amazon-ebs.ubuntu: AMIs were created:
us-west-2: ami-0fb58842ec2e0b5a7

2021/06/29 21:47:30 [INFO] (telemetry) Finalizing.
2021/06/29 21:47:31 waiting for all plugin processes to complete...
2021/06/29 21:47:31 /usr/local/bin/packer: plugin process exited
...
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
