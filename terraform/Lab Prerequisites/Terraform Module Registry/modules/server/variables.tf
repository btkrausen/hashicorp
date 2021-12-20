variable "ami" {}
variable "size" {
  # default = "t2.micro"
}
variable "subnet_id" {}
variable "security_groups" {
  type = list(any)
}