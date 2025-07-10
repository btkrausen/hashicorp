# Nomad-Specific Variables
variable "nomad_servers" {
  description = "list of host names for Nomad servers"
  type        = list(string)
  default     = []
}

variable "nomad_clients" {
  description = "list of host names for Nomad clients"
  type        = list(string)
  default     = []
}

# AWS-Specific Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the EC2 instances"
  type        = bool
  default     = false
}

variable "ec2_key_name" {
  description = "Name of the EC2 key pair to use for SSH access"
  type        = string
  default     = ""
}

variable "ec2_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instances"
  type        = list(string)
  default     = []
}

variable "nomad_server_subnet_id" {
  description = "Subnet ID for Nomad server instances"
  type        = string
  default     = ""
}

variable "nomad_client_subnet_id" {
  description = "Subnet ID for Nomad client instances"
  type        = string
  default     = ""
}

variable "nomad_server_ec2_instance_type" {
  description = "Instance type for Nomad server instances"
  type        = string
  default     = "t3.medium"

}

variable "nomad_client_ec2_instance_type" {
  description = "Instance type for Nomad client instances"
  type        = string
  default     = "t3.medium"
}