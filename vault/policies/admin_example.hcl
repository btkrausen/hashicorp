# #############################
# ### Vault Policy - Admin ####
# #############################

# permit access to all sys backend configurations to administer Vault itself
# note that some sys/ paths require sudo
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# manage Vault auth methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# manage Vault identities
path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# permit access to administer secrets KV secrets engine - admin cannot read secrets
path "secrets/*" {
  capabilities = ["create", "update", "delete"]
}

# permit access to list secrets KV v2 secrets engine
path "secrets/metadata/*" {
  capabilities = ["read", "list"]
}

# permit access to administer the AWS secrets engine
path "aws-secrets/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# permit access to administer the OIDC auth method
path "oidc/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# permit access to administer the userpass auth method
path "userpass/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
