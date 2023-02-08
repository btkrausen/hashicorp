#!/bin/bash

# Install dependencies
echo "Installing Dependencies"
sudo yum update -y
sudo yum install install -y jq
sudo yum install -y yum-utils

# Download and Install Nomad via Package Manager
echo "Installing Nomad via Package Manager"
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install nomad

# Write a Server Configuration File
echo "Writing the Nomad configuration file"
rm -f /etc/nomad.d/nomad.hcl
sudo cat << EOF > /etc/nomad.d/nomad.hcl
name = "nomad_server_a" # Update for each node name in the cluster

# Directory to store agent state
data_dir = "/etc/nomad.d/data"

# Address the Nomad agent should bing to for networking
# 0.0.0.0 is the default and results in using the default private network interface
# Any configurations under the addresses parameter will take precedence over this value
bind_addr = "0.0.0.0"

advertise {
  # Defaults to the first private IP address.
  http = "10.0.102.110" # must be reachable by Nomad CLI clients
  rpc  = "10.0.102.110" # must be reachable by Nomad client nodes
  serf = "10.0.102.110" # must be reachable by Nomad server nodes
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

# TLS configurations
tls {
  http = true
  rpc  = true

  ca_file   = "/etc/certs/ca.crt"
  cert_file = "/etc/certs/nomad.crt"
  key_file  = "/etc/certs/nomad.key"
}

# Specify the datacenter the agent is a member of
datacenter = "dc1"

# Logging Configurations
log_level = "INFO"
log_file  = "/etc/nomad.d/nomad.log"

# Server & Raft configuration
server {
  enabled          = true
  bootstrap_expect = 3

  encrypt = "Do7GerAsNtzK527dxRZJwpJANdS2NTFbKJIxIod84u0=" # use command [$ nomad operator gossip keyring generate] to generate
  # license_path = "opt/nomad.d/nomad.hclic"
}

# Client Configuration - Node can be Server & Client
client {
  enabled = false
}

# [optional] Specifies configuration for connecting to Consul
// consul {
//   address = "https://consul.example.com:8500"
// }

# [optional] Specifies configuration for connecting to Vault
// vault {
//   enabled     = true
//   address     = "https://vault.example.com:8200"
//   ca_path     = "/etc/certs/ca"
//   cert_file   = "/var/certs/vault.crt"
//   key_file    = "/var/certs/vault.key"
// }
EOF

# Enable and Start the Nomad Service
echo "Enabling and Starting the Nomad Service"
sudo systemctl enable nomad
sudo systemctl start nomad

echo "Completed"
