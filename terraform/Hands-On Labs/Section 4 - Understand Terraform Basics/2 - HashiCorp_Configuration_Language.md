# Lab: HashiCorp Configuration Language

Terraform is written in HCL (HashiCorp Configuration Language) and is designed to be both human and machine readable. HCL is built using code configuration blocks which typically follow the following syntax:

```hcl
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

Terraform Code Configuration block types include:

- Terraform Configuration Block
- Terraform Provider Block
- Terraform Resource Block
- Terraform Data Block
- Terraform Input Variables Block
- Terraform Local Variables Block
- Terraform Output Values Block
- Terraform Modules Block

This course will go through each of these configuration blocks in more detail throughout the course.

## Terraform Configuration Block

## Terraform Provider Block

## Terraform Resource Block

Resource Blocks within Terraform HCL are comprised of the following components:

- Resource Block - "resource" is a top-level keyword like "for" and "while" in other programming languages.
- Resource Type - The next value is the type of the resource. Resources types are always prefixed with their provider (aws in this case). There can be multiple resources of the same type in a Terraform configuration.
- Resource Local Name - The next value is the name of the resource. The resource type and name together form the resource identifier, or ID. In this case, the resource ID is `aws_instance.ec2-vm`. The resource ID must be unique for a given configuration, even if multiple files are used.
- Resource Arguments - Most of the arguments within the body of a resource block are specific to the selected resource type. The resource type's documentation lists which arguments are available and how their values should be formatted.
- Resource Meta-Arguments - The Terraform language defines several meta-arguments, which can be used with any resource type to change the behavior of resources. Examples of Meta-Arguments include `depends_on`, `count`, and `for_each`. An overview of Meta-Arguments is provided in Objective 8 of the course.

Here is a sample Terraform resource block for building an EC2 instance. Let's take a moment to review the components here.

```hcl
# Terraform Resource Block - To Build EC2
resource "aws_instance" "ec2-vm" {
  ami               = "ami-047a51fa27710816e"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "EC2 Server"
  }
}
```

In the example above the resource block declares a resource of a given type (`aws_instance`) with a given local name (`ec2-vm`). The name is used to refer to this resource from elsewhere in the same Terraform module. The resource type and name together form the resource identifier, or ID. In this case, the resource ID is `aws_instance.ec2-vm`. This resource has four attributes declared: `ami`, `instance_type`, `availablity_zone` and `tags`. There are currently no meta-arguments in this resource code block.

The arguments of a resource block can staticly defined, accept variables or terraform expressions. Below is another example of a EC2 resource block. This time we are creating a resource block with the same resource type, but a different resource name: `web_server`

```hcl
# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" { # BLOCK
  ami           = data.aws_ami.ubuntu.id # Argument with data expression
  instance_type = "t2.micro" # Argument
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id # Argument with value as expression
  tags = {
    Name = "Web EC2 Server"
  }
}
```

## Terraform Data Block

Data Blocks within Terraform HCL are comprised of the following components:

Data Block - "resource" is a top-level keyword like "for" and "while" in other programming languages.
Data Type - The next value is the type of the resource. Resources types are always prefixed with their provider (aws in this case). There can be multiple resources of the same type in a Terraform configuration.
Data Local Name - The next value is the name of the resource. The resource type and name together form the resource identifier, or ID. In this case, the resource ID is aws_instance.web. The resource ID must be unique for a given configuration, even if multiple files are used.
Data Arguments - Most of the arguments within the body of a resource block are specific to the selected resource type. The resource type's documentation lists which arguments are available and how their values should be formatted.

Example:
A data block requests that Terraform read from a given data source ("aws_ami") and export the result under the given local name ("example"). The name is used to refer to this resource from elsewhere in the same Terraform module.

```hcl
# Terraform Data Block - Lookup Ubuntu 20.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
```

## Terraform Input Variables Block

## Terraform Local Variables Block

## Terraform Output Values Block

## Terraform Modules Block
