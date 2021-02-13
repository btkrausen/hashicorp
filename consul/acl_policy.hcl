node_prefix "web-server-01" {
  policy = "write"
}
service_prefix "eCommerce-Front-End" {
  policy = "write"
}
session_prefix "" {
  policy = "write"
}
key_prefix "kv/apps/eCommerce" {
  policy = "read"
}