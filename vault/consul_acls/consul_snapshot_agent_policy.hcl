# Give Consul Snapshot Agent privileges to take snapshots
acl = "write"
key "consul-snapshot/lock" {
  policy = "write"
}
session_prefix "" {
  policy = "write"
}
service "consul-snapshot" {
  policy = "write"
}
