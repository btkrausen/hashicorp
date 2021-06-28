# Lab: Packer Breakpoints

Duration: 10 minutes

## Breakpoints
The breakpoint provisioner will pause until the user presses "enter" to resume the build. This is intended for debugging purposes, and allows you to halt at a particular part of the provisioning process. This is independent of the -debug flag, which will instead halt at every step and between every provisioner.

Breakpoints are especially useful for troubleshooting items within a provisoner as it leaves the Virtual Machine running before erroring or creating an image.

## Using Breakpoints

### Create a Packer Template

Create a `packer-breakpoints.pkr.hcl` Packer Template

```hcl
source "null" "debug" {
  communicator = "none"
}

build {
  sources = ["source.null.debug"]

  provisioner "shell-local" {
    inline = ["echo hi"]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "this is a breakpoint"
  }

  provisioner "shell-local" {
    inline = ["echo hi 2"]
  }

}
```

### Execute a Packer Build

`packer build packer-breakpoints.prk.hcl`

The build should run straight through to completion; you should see output that
reads

```bash
> Breakpoint provisioner with note "this is a breakpoint" disabled; continuing...
```

Open up the `packer-breakpoints.prk.hcl` file and change `disable": false` from the
breakpont provisioner definition.

Run `packer build packer-breakpoints.prk.hcl` again. This time you'll see the output

>==> null: Pausing at breakpoint provisioner with note "this is a breakpoint".
>==> null: Press enter to continue.

The build will remain paused until you press enter to continue it, allowing
you all the time you need to navigate to investigate your build environment.