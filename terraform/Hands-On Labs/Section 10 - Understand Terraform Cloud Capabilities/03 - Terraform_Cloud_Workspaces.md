# Lab: Terraform Cloud Workspaces

A Terraform workspace is a managed unit of infrastructure. Workspaces are the workhorse of Terraform Cloud and build on the Terraform CLI workspace construct. Each uses the same Terraform code to deploy infrastructure and each keeps separate state data for each workspace. Terraform Cloud simply adds more functionality. On your local workstation, the terraform workspace is simply a directory full of terraform code and variables. This code is also ideally stored in a git repository. Terraform Cloud workspaces take on some extra roles. In Terraform Cloud your workspace stores state data, has it's own set variable values and environment variables, and allows for remote operations and logging. Terraform Cloud workspaces also provide access controls, version control integration, API access and policy management.

This lab demonstrates how to utilize workspaces within Terraform Cloud.

- Task 1: Review Terraform Cloud Workspaces User Interface
- Task 2: Create a Terraform Cloud Workspace for DEV deployments
- Task 3: Create a Terraform Cloud Workspace for PROD developments
- Task 4: Assign and set variables per workspace
- Task 5: Change Terraform versions per workspace
- Task 6: Deploy infrastructure using Terraform Cloud workspaces

## Task 1: Review Terraform Cloud Workspaces Features

Now that we have our state and variables stored in our Terraform Cloud workspace and have begun to execute remote runs within the workspace, let's look at some of the other features that Terraform Cloud workspaces have to offer.

### 1.1 Workspace Dashboard

The landing page for a workspace includes an overview of its current state and configuration.

![Terraform Cloud Workspace - Overview](img/tfc_workspace_overview.png)

You quickly find resource count, terraform version, and the time since the last update. You can view the latest information about last run including who performed the run, how the run was triggered, which resources changed, the duration of the run, along with the cost change. For further details you can jump into the he Runs tab to see all historical runs.

![Terraform Cloud Workspace - Historical Runs](img/tfc_workspace_run_history.png)

The **Actions** menu allows you to lock the workspace or trigger a new run. The resources and outputs tables display details about the current infrastructure and any outputs configured for the workspace. The sidebar contains metrics and details about workspace settings. It also includes a section for workspace tags. You can manage your workspace's tags here, and your list of tags in your Organization settings. Tags allow you to group and filter your workspaces.

### 1.2 Remote or Local Runs

As we have shown by using the `remote` backend, Terraform operations like plan or apply can now be run within Terraform Cloud on a hosted agent which saves the results and logs to the workspace. This gives you a standardized working environment for all Terraform runs and possibly more importantly, a single place to go and inspect logs when something goes wrong.

![Terraform Cloud Workspace - Execution Mode](img/tfc_workspace_execution_mode.png)

You can also choose betwen remote and local execution on a per workspace basis.

### 1.3 Terraform Version

When operating in Remote execution mode we can also specify the version of Terraform for the hosted agent to run without having to worry about the Terraform version installed on the local machine.

![Terraform Cloud Workspace - Terraform Version](img/tfc_workspace_tf_version.png)

The Terraform core version can be specified on a per workspace basis and can differ between workspaces.Workspaces make it easy to standardize and upgrade when the time comes.

### 1.4 Team Access

Each workspace can be configured with team access permissions. The Team Access category allows you to define which teams have access to the workspace and what level of access they have. There are pre-canned levels of access, like read, plan, write, and admin, or you can construct your own custom permission sets.

![Terraform Cloud Workspace - Team Access](img/tfc_workspace_teams.png)

![Terraform Cloud Workspace - Team Access](img/tfc_workspace_permissions.png)

### 1.5 Notifications

Moving over to the notifications category, when something happens with the workspace, you can trigger a notification to be sent to an email address, slack channel, or webhook. This is great if you want to be notified when a new plan needs to be approved or an apply went horribly wrong.

![Terraform Cloud Workspace - Notifications](img/tfc_workspace_notifications.png)

### 1.6 Workflows: CLI/VCS/API Integration

When you create a new workspace, Terraform Cloud will ask what type of workflow will be used by the workspace. You will be presented with three options, CLI, VCS, and API.

![Terraform Cloud Workspace - Notifications](img/tfc_workspace_workflows.png)

We have been operating within the CLI workflow up to this point in the course, triggering all commands from the command line. You control the Terraform workflow from the CLI with standard Terraform commands like plan and apply.

The VCS or version control system workflow is the most common option, but it also requires that you host the Terraform code in a VCS repository. Events on the repository will trigger workflows on Terraform Cloud. For instance, a commit to the default branch could kick off a plan and apply workflow in Terraform Cloud.

If you need more customized automation and workflows than what is available in Terraform Cloud, you can use an API workflow to integrate Terraform Cloud into a larger automation pipeline. For instance, if you are already using Jenkins or CI/CD Pipelines to automate your IaC deployment, you can hook Terraform Cloud in to handle the Terraform actions.

## Task 2: Create a Terraform Cloud Workspace for DEV deployments

A workspace name has to be all lower case letters, numbers, and dashes. The recommended naming convention from HashiCorp is the team name, the cloud the infrastructure will be deployed in, the application or purpose of the infrastructure, and the environment, whether it's dev, staging, prod, etc. Workspace names are relative to the organization, so they do not have to be globally unique, only unique within the organization.

Suggested workspace naming convention <team>-<cloud>-<app>-<environment>, e.g. devops-aws-myapp-dev which makes it easier to filter, navigate and performed automated operations against Terraform Cloud workspaces.

Let's create a new development workspace for your app called: `devops-aws-myapp-dev`

1. Select `New Workspace` and choose the `CLI-driven workflow`
2. Give the workspace a name of `devops-aws-myapp-dev`
3. Select `Create Workspace`

## Task 3: Create a Terraform Cloud Workspace for PROD deployments

The state data in a workspace can also be shared with other workspaces in the organization as a data source. That's helpful if you decide to refactor your Terraform code into separate workspaces, but you need to pass information between them.

To isoloate our production deployment from our development, let's create a new workspace for our production infrastructure named: `devops-aws-myapp-prod`

1. Select `New Workspace` and choose the `CLI-driven workflow`
2. Give the workspace a name of `devops-aws-myapp-prod`
3. Select `Create Workspace`

## Task 4: Assign and set variables per workspace

### 3.1 - Assign Variables to DEV workspace

- Navigate to your Terraform Cloud `devops-aws-myapp-dev` workspace
- Once there, navigate to the `Variables` tab.
- In the `Variables` tab, you can add variables related to the state file that was previously migrated.
- To do this, first select the `+ Add variable` button
- Let's add a Terraform variable named `aws_region` with a value of `us-east-1`
- Let's add a second Terraform variable named `vpc_name` with a value of `dev_vpc`
- Let's add a third Terraform variable named `environment` with a value of `dev`
- Choose the `Apply variable set` option to apply the `AWS Credentials` variable set

### 3.2 - Assign Variables to PROD workspace

- Navigate to your Terraform Cloud `devops-aws-myapp-prod` workspace
- Once there, navigate to the `Variables` tab.
- In the `Variables` tab, you can add variables related to the state file that was previously migrated.
- To do this, first select the `+ Add variable` button
- Let's add a Terraform variable named `aws_region` with a value of `us-east-1`
- Let's add a second Terraform variable named `vpc_name` with a value of `prod_vpc`
- Let's add a third Terraform variable named `environment` with a value of `prod`
- Choose the `Apply variable set` option to apply the `AWS Credentials` variable set

## Task 5: Change Terraform versions per workspace

Modify the Terraform version for the development workspace to use `1.1.2` to test if the deployments are compatabile with that release and set production workspace at terraform version `1.0.11`

To set the Terraform version for a workspace navigate to `Settings > General` of the workspace and specify the appropriate Terraform core version.

## Task 6: Deploy infrastructure using Terraform Cloud workspaces

### 6.1 - Declare Environment variables

The last step is to now deploy our infrastructure into the appropriate workspace. Now that our infrastructure will be broken up by environment, let's declare a variable in our `variables.tf` named `environment`

`variables.tf`

```hcl
variable "environment" {
  type = string
  description = "Infrastructure environment. eg. dev, prod, etc"
  default = "test"
}
```

Let's also update a couple of our resource blocks inside the `main.tf` to make use of this new enviornment variable.

`main.tf`

```
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    Terraform   = "true"
  }

  enable_dns_hostnames = true
}


resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey${var.environment}"
  public_key = tls_private_key.generated.public_key_openssh
}
```

### 6.2 - Deploy infrastructure using appropriate Terraform Cloud workspaces

Since we have Terraform Cloud workspaces that share the same Terraform codebase we will leverage backend partial configuration to select the correct workspace. If you are unfamilar with Terraform backend partial configuration it is recommended you reveiew the Terraform Backend Configuration lab which explains it in detail.

Create two new files in our working directory called `dev.hcl` and `prod.hcl`

`dev.hcl`

```hcl
workspaces { name="devops-aws-myapp-dev"}
```

`prod.hcl`

```hcl
workspaces { name="devops-aws-myapp-prod"}
```

Initialize and apply configuration in the development workspace.

```bash
terraform init -backend-config=dev.hcl -reconfigure
terraform plan
terraform apply
```

Initialize and apply configuration in the production workspace.

```bash
terraform init -backend-config=prod.hcl -reconfigure
terraform plan
terraform apply
```

You can view each of these deployments from either the CLI or Terraform Cloud interface. The infrastructure can be validated by looking at the Terraform Cloud workspace dashboard.

![Terraform Cloud Workspace - Dashboard](img/tfc_workspace_dashboard.png)

### 6.3 - Destroy infrastructure in appropriate workspace

If you would like to cleanup and destroy your infrastructure to keep costs down, that can be done at the workspace level. Navigate to the `Settings` of the workspace and select `Destruction and Deletion`. That will provide you with the ability to `Queue destroy plan` which follows the same workflow as a `terraform destroy`. Be sure not to delete the workspace itself (which is also an option on this same page) as in a future lab we will connect these new workspaces to the VCS workflow trigger runs based on code commits rather than via CLI.

![Terraform Cloud Workspace - Dashboard](img/tfc_workspace_destroy_plan.png)

## What belongs in a workspace?

Often times we are asked - What should I put in a workspace? We recommend infrastructure that should be managed together as a unit be placed into the same workspace. Who has to manage it, how often does it change, does it have external dependencies that we can't control. Ask these questions. Think about what happens when you run terraform apply. You should be able to describe what you just built, and what outputs it provides, who this infrastructure is for, and how to utilize it.

A workspace could be: An entire application stack from network on up. Great for dev environments that you want to be completely self-contained. Or it could be a workspace that builds core network infrastructure and nothing else. Maybe the network team has to manage that. They get to be the lords of the network and provide terraform outputs to those who need a VPC or subnet. You can also use workspaces to deploy platform services like Kubernetes.
