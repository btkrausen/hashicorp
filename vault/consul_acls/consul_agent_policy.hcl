#Used for the Consul agent policy for Vault nodes
#A token is generated from this policy and added to the Consul config on the Vault node
node_prefix "" {
  policy = "write"
}
service_prefix "" {
  policy = "read"
}
agent_prefix "" {
  policy = "write"
}
