#This policy is for Consul server nodes.
#A token is generated from this policy and token is added to the Consul configuration

node_prefix "" {
  policy = "write"
}
agent_prefix "" {
  policy = "write"
}
service_prefix "consul" {
  policy = "write"
}
service_prefix "" {
  policy = "read"
}
