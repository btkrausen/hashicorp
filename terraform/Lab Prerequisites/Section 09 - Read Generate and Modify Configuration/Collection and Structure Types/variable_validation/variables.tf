terraform {
  backend "remote" {
    organization = "krausen"

    workspaces {
      name = "variable_validation"
    }
  }
}


variable "cloud" {
  type = string

  validation {
    condition     = contains(["aws", "azure", "gcp", "vmware"], lower(var.cloud))
    error_message = "You must use an approved cloud."
  }

  validation {
    condition     = lower(var.cloud) == var.cloud
    error_message = "The cloud name must not have capital letters."
  }
}

variable "no_caps" {
  type = string

  validation {
    condition     = lower(var.no_caps) == var.no_caps
    error_message = "Value must be in all lower case."
  }

}

variable "character_limit" {
  type = string

  validation {
    condition     = length(var.character_limit) == 3
    error_message = "This variable must contain only 3 characters."
  }
}

variable "ip_address" {
  type = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address))
    error_message = "Must be an IP address of the form X.X.X.X."
  }
}

variable "phone_number" {
  type      = string
  sensitive = true
  default   = "867-5309"
}

locals {
  contact_info = {
    cloud        = var.cloud
    department   = var.no_caps
    cost_code    = var.character_limit
    phone_number = var.phone_number
  }

  my_number = nonsensitive(var.phone_number)
}

output "cloud" {
  value = local.contact_info.cloud
}

output "department" {
  value = local.contact_info.department
}

output "cost_code" {
  value = local.contact_info.cost_code
}

output "phone_number" {
  sensitive = true
  value     = local.contact_info.phone_number
}

output "my_number" {
  value = local.my_number
}
