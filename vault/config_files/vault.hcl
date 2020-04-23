storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
  token   = "xxx"
}
listener "tcp" {
 address = "0.0.0.0:8200"
 cluster_address = "0.0.0.0:8201"
 tls_disable = 0
 tls_cert_file = "/etc/vault.d/client.pem"
 tls_key_file = "/etc/vault.d/cert.key"
 tls_disable_client_certs= "true"
}
seal "awskms" {
  region = "us-east-1"
  kms_key_id = "xxxx",
  endpoint = "xxx.kms.us-east-1.vpce.amazonaws.com"
}
api_addr = "https://vault.example.com:8200"
ui = true
cluster_addr = "https://10.10.10.10:8201"
cluster_name = "vault-prod-us-east-1"
