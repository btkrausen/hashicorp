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
2021/06/29 21:24:09 [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:24:09 [TRACE] discovering plugins in /usr/local/bin
2021/06/29 21:24:09 [TRACE] discovering plugins in /Users/gabe/.packer.d/plugins
2021/06/29 21:24:09 [TRACE] discovering plugins in .
2021/06/29 21:24:09 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:24:09 [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:24:09 [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:24:09 [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:24:09 [TRACE] Starting internal plugin packer-builder-amazon-ebs
2021/06/29 21:24:09 Starting plugin: /usr/local/bin/packer []string{"/usr/local/bin/packer", "plugin", "packer-builder-amazon-ebs"}
2021/06/29 21:24:09 Waiting for RPC address for: /usr/local/bin/packer
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] Packer version: 1.7.2 [go1.16.3 darwin amd64]
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /Users/gabe/.packerconfig
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [WARN] Config file doesn't exist: /Users/gabe/.packerconfig
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] Setting cache directory: /Users/gabe/repos/packer_training/labs/debug_lab/packer_cache
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: args: []string{"packer-builder-amazon-ebs"}
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: Plugin address: unix /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin532870282
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: Waiting for connection...
2021/06/29 21:24:09 Received unix RPC address for /usr/local/bin/packer: addr is /var/folders/1c/qvs1hwp964z_dwd5qg07lv_00000gn/T/packer-plugin532870282
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: Serving a plugin connection...
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] (aws): No AWS timeout and polling overrides have been set. Packer will default to waiter-specific delays and timeouts. If you would like to customize the length of time between retries and max number of retries you may do so by setting the environment variables AWS_POLL_DELAY_SECONDS and AWS_MAX_ATTEMPTS or the configuration options aws_polling_delay_seconds and aws_polling_max_attempts to your desired values.
2021/06/29 21:24:09 ui: [1;32mamazon-ebs.ubuntu: output will be in this color.[0m
2021/06/29 21:24:09 ui: 
2021/06/29 21:24:09 Build debug mode: false
2021/06/29 21:24:09 Force build: false
2021/06/29 21:24:09 On error: 
2021/06/29 21:24:09 Waiting on builds to complete...
2021/06/29 21:24:09 Starting build run: amazon-ebs.ubuntu
2021/06/29 21:24:09 Running builder: 
2021/06/29 21:24:09 [INFO] (telemetry) Starting builder 
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] AWS Auth provider used: "SharedCredentialsProvider"
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: Found region us-west-2
2021/06/29 21:24:09 packer-builder-amazon-ebs plugin: [INFO] AWS Auth provider used: "SharedCredentialsProvider"
2021/06/29 21:24:10 ui: [1;32m==> amazon-ebs.ubuntu: Prevalidating any provided VPC information[0m
2021/06/29 21:24:10 ui: [1;32m==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-1625016249[0m
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin: Using AMI Filters {
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:   Filters: [{
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Name: "name",
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Values: ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"]
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:     },{
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Name: "root-device-type",
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Values: ["ebs"]
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:     },{
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Name: "virtualization-type",
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:       Values: ["hvm"]
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:     }],
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin:   Owners: ["099720109477"]
2021/06/29 21:24:11 packer-builder-amazon-ebs plugin: }
2021/06/29 21:24:11 ui: [0;32m    amazon-ebs.ubuntu: Found Image ID: ami-01773ce53581acf22[0m
2021/06/29 21:24:11 ui: [1;32m==> amazon-ebs.ubuntu: Creating temporary keypair: packer_60dbc7b9-fef3-543e-4b22-f5e99c635796[0m
2021/06/29 21:24:11 ui: [1;32m==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_60dbc7bb-fc1b-8851-31d4-9cb60e099abf[0m
2021/06/29 21:24:12 packer-builder-amazon-ebs plugin: [DEBUG] Waiting for temporary security group: sg-070eea0bac531d51e
2021/06/29 21:24:12 packer-builder-amazon-ebs plugin: [DEBUG] Found security group sg-070eea0bac531d51e
2021/06/29 21:24:12 ui: [1;32m==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...[0m
2021/06/29 21:24:13 ui: [1;32m==> amazon-ebs.ubuntu: Launching a source AWS instance...[0m
2021/06/29 21:24:13 ui: [1;32m==> amazon-ebs.ubuntu: Adding tags to source instance[0m
2021/06/29 21:24:13 ui: [0;32m    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"[0m
2021/06/29 21:24:15 ui: [0;32m    amazon-ebs.ubuntu: Instance ID: i-0340d75bdbe279c59[0m
2021/06/29 21:24:15 ui: [1;32m==> amazon-ebs.ubuntu: Waiting for instance (i-0340d75bdbe279c59) to become ready...
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
packer build -debug
```

## Task 5: Inspect Failures
Packer provides the ability to inspect failures during the debug process.

`packer build -on-error=ask` allows you to inspect failures and try out solutions before restarting the build.

```shell
packer build -on-error=ask
```
