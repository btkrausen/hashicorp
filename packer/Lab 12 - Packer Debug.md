# Lab: Debugging Packer
Often times it becomes necessary to turn on debugging when performing Packer image builds.  Packer supports several ways in which to enable and work with debugging.

- Task 1: Enable Packer Logging and Set Log Path
- Task 2: Enable debugging mode via Packer build
- Task 3: Inspect Failures

Duration: 15 minutes

## Task 1: Enable Logging

### Step 11.1.1

Packer has detailed logs which can be enabled by setting the `PACKER_LOG` environment variable to `1`. This will cause detailed logs to appear on stderr.

Linux

```bash
> export PACKER_LOG=1
```

PowerShell

```shell
> $env:PACKER_LOG=1
```

Example Output

```shell
```

### Step 11.1.2

To persist logged output you can set PACKER_LOG_PATH in order to force the log to always be appended to a specific file when logging is enabled. Note that even when PACKER_LOG_PATH is set, PACKER_LOG must be set in order for any logging to be enabled.

```bash
> export PACKER_LOG_PATH="packer_log.txt"
```

PowerShell

```shell
> $env:PACKER_LOG_PATH="packer_log.txt"
```

Open the `packer_log.txt` to see the contents of the debug trace for your packer build.

## Task 2: Enable debugging mode via Packer build
For remote builds with cloud providers like Amazon Web Services AMIs, debugging a Packer build can be eased greatly with `packer build -debug`. This disables parallelization and enables debug mode.

```shell
packer build -debug
```

## Task 3: Inspect Failures
Packer provides the ability to inspect failures during the debug process.

packer build -on-error=ask allows you to inspect failures and try out solutions before restarting the build.