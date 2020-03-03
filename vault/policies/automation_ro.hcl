path "secrets/data/automation/*" {
  capabilities = ["read"]
}
path "secrets/metadata/automation/*" {
  capabilities = ["list", "read"]
}
#Permit list for browsing the user interface
path "secrets/metadata/*" {
  capabilities = ["list"]
}
