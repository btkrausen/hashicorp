# Terraform to Deploy Nomad on AWS EC2

If you're looking to deploy Nomad for a test environment or to learn it, this Terraform will quickly get you up and running. 

## Infrastructure Details

Without modification, this will create 3 x Nomad servers and 3 x Nomad clients. All are joined to the cluster using Cloud AutoJoin via tags. Make sure the role that gets attached to the nodes include the `ec2:DescribeInstances` permission (maybe I should just add that to the Terraform).

## Software Packages Installed

The scripts will install Nomad, Consul, Docker, and CNI plugins needed to get up and running very quickly.