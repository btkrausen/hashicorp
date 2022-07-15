log_level  = "INFO"
server     = true
datacenter = "us-east-1"
primary_datacenter = "dc1"

ui_config {
  enabled = true
}

# TLS Configuration
key_file               = "/etc/consul.d/cert.key"
cert_file              = "/etc/consul.d/client.pem"
ca_file                = "/etc/consul.d/chain.pem"
verify_incoming        = true
verify_outgoing        = true
verify_server_hostname = true

# Gossip Encryption - generate key using consul keygen
encrypt                = "pCOEKgL2SYHmDoFJqnolFUTJi7Vy+Qwyry04WIZUupc="

leave_on_terminate = true
data_dir           = "/opt/consul/data"

# Agent Network Configuration
client_addr    = "0.0.0.0"
bind_addr      = "10.0.0.170"
advertise_addr = "10.0.0.170"

# Disable HTTP and use 8501 for HTTPS
ports {
  http  = -1
  https = 8501
}

# Cluster Join - Using Cloud Auto Join
bootstrap_expect = 5
retry_join       = ["provider=aws tag_key=Environment-Name tag_value=consul-cluster region=us-east-1"]

# Enable and Configure Consul ACLs
acl = {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"
  tokens = {
    agent = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
}

# Set raft multiplier to lowest value (best performance) - 1 is recommended for Production servers
performance = {
    raft_multiplier = 1
}

# Enables auto encrypt for distribution of certs to Consul clients from the Connect CA
auto_encrypt {
  allow_tls = true
}

# Enable service mesh capability for Consul datacenter
connect = {
  enabled = true
}

