module "nomad-server" {
  for_each = toset(var.nomad_servers)
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "6.0.1"

  ami                         = var.ec2_ami_id
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = aws_iam_instance_profile.nomad.name
  instance_type               = var.nomad_server_ec2_instance_type
  key_name                    = var.ec2_key_name
  name                        = each.key
  subnet_id                   = var.nomad_server_subnet_id
  vpc_security_group_ids      = var.ec2_security_group_ids
  create_security_group       = false

  tags = {
    Name             = each.key
    Owner            = "Infrastructure Team"
    Purpose          = "Nomad Cluster Testing"
    Environment-Name = "nomad-cluster"
  }

  user_data = templatefile("./scripts/nomad_server_install.tmpl", {
    host_name = each.key
  })
}

module "nomad-client" {
  for_each = toset(var.nomad_clients)
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "6.0.1"

  ami                         = var.ec2_ami_id
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = aws_iam_instance_profile.nomad.name
  instance_type               = var.nomad_client_ec2_instance_type
  key_name                    = var.ec2_key_name
  name                        = each.key
  subnet_id                   = var.nomad_client_subnet_id
  vpc_security_group_ids      = var.ec2_security_group_ids
  create_security_group       = false

  tags = {
    Name             = each.key
    Owner            = "Infrastructure Team"
    Purpose          = "Nomad Cluster Testing"
    Environment-Name = "nomad-cluster"
  }

  user_data = templatefile("./scripts/nomad_client_install.tmpl", {
    host_name = each.key
  })
}

resource "aws_iam_instance_profile" "nomad" {
  name = "nomad_profile"
  role = "nomad_server"
}