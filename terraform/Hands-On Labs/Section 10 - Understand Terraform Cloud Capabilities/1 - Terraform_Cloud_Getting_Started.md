# Lab: Terraform Cloud - Getting Started

Terraform Cloud is HashiCorp’s managed service offering that eliminates the need for unnecessary tooling and documentation to use Terraform in production. Terraforn Cloud helps you to provision infrastructure securely and reliably in the cloud with free remote state storage. Teraform Cloud and it's self hosted counterpart Terraform Enterprise offer Workspaces, Private Module Registry, Team Goverenance along with Policy as Code (Sentinel) as a few of it's benefits.

- Task 1: Sign up for Terraform Cloud
- Task 2: Clone Getting Started Code Repository
- Task 3: Run setup script to create TFC Organization for course

## Task 1: Sign up for Terraform Cloud

In this lab you will sign up and get started with Terraform Cloud utilize the [Terraform Cloud](https://app.terraform.io/).

1. Navigate to [the sign up page](https://app.terraform.io/signup?utm_source=banner&utm_campaign=intro_tf_cloud_remote) and create an account for Terraform Cloud. If you already have a TFC account

1. Perform a `terraform login` from your workstation

```bash
Terraform will request an API token for app.terraform.io using your browser.

If login is successful, Terraform will store the token in plain text in
the following file for use by subsequent commands:
    /home/student/.terraform.d/credentials.tfrc.json

Do you want to proceed?
  Only 'yes' will be accepted to confirm.

  Enter a value:
```

2. Answer `yes` at the prompt and generate a TFC user token by following the URL provided and copy-paste it into the prompt.

```bash
---------------------------------------------------------------------------------

Open the following URL to access the tokens page for app.terraform.io:
    https://app.terraform.io/app/settings/tokens?source=terraform-login


---------------------------------------------------------------------------------
```

1. If the token was entered succesfully you should see the following:

```bash

Retrieved token for user tfcuser


---------------------------------------------------------------------------------

                                          -
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to Terraform Cloud!                     -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to TFC? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh

```

## Task 2: Clone Getting Started Code Repository

We will utilize a sample code repo to get started with Terraform Cloud. You can clone this sample repo using the following conmmands:

```sh
git clone https://github.com/hashicorp/tfc-getting-started.git
cd tfc-getting-started
```

## Task 3: Run setup script to create TFC Organization for course

This startup script within the sample code repo automatically handles all the setup required to start using Terraform with Terraform Cloud. The included configuration provisions some mock infrastructure to a fictitious cloud provider called "Fake Web Services" using the [`fakewebservices`](https://registry.terraform.io/providers/hashicorp/fakewebservices/latest) provider.

```
./scripts/setup.sh
```

Follow the prompts provided by the script which will create a Terraform organization along with mock infrastructure.

```bash
--------------------------------------------------------------------------
Getting Started with Terraform Cloud
-------------------------------------------------------------------------

Terraform Cloud offers secure, easy-to-use remote state management and allows
you to run Terraform remotely in a controlled environment. Terraform Cloud runs
can be performed on demand or triggered automatically by various events.

This script will set up everything you need to get started. You'll be
applying some example infrastructure - for free - in less than a minute.

First, we'll do some setup and configure Terraform to use Terraform Cloud.

Press any key to continue (ctrl-c to quit):
```

```
You did it! You just provisioned infrastructure with Terraform Cloud! The organization we created here has a 30-day free trial of the Team & Governance tier features.
```

Navigate to your workspace, along with mock infrastruture that you just deployed:

- Terraform Cloud: https://app.terraform.io/

- Mock infrastructure you just provisioned: https://app.terraform.io/fake-web-services
