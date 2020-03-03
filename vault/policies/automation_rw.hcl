#To manage the secrets
path "secrets/data/automation/*" {
  capabilities = ["read", "create", "update", "delete"]
}
#To allow a token to list, view, and permanently remove all versions and metadata keys
path "secrets/metadata/automation/*" {
  capabilities = ["list", "read", "delete"]
}
#To allow a token to delete any version of a key
path "secrets/delete/automation/*" {
  capabilities = ["update"]
}
#To allow a token to undelete any version of a key
path "secrets/undelete/automation/*" {
  capabilities = ["update"]
}
#To allow a token to destroy versions of a key
path "secrets/destroy/automation/*" {
  capabilities = ["update"]
}
#Permit list for browsing the user interface
path "secrets/metadata/*" {
  capabilities = ["list"]
}
