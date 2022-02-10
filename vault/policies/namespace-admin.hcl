#####################################
#### Namespace Admin Permissions ####
#####################################

# Auth and Policies Permissions

# Allow Managing Leases
path "sys/leases/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage AppRole Auth Method within Namespace
path "auth/approle/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage AWS Auth Method within Namespace
path "auth/aws/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List Auth Methods
path "sys/auth" {
  capabilities = ["read", "list"]
}

# List Existing Policies
path "sys/policies/acl" {
  capabilities = ["read", "list"]
}

# Create and Manage ACL Policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Deny Modification of Namespace Admin ACL Policy
path "sys/policies/acl/namespace-admin" {
  capabilities = ["deny"]
}

# List and Read "identity" endpoints
path "identity/" {
  capabilities = ["read", "list"]
}

# Read and list access to view Vault entities, groups and identities
path "identity/*" {
  capabilities = ["read", "list"]
}

# Allows lookup of entities, aliases and groups (requires "POST" permissions, ie: create and update). This is not essential but helpful.
path "identity/lookup/*" {
  capabilities = ["create", "update"]
}

# Secrets Engines Permissions

# Manage Secrets Engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List Existing Secrets Engines
path "sys/mounts" {
  capabilities = ["read", "list"]
}

# Create and Manage Child Namespaces

# Manage child namespaces
path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List Child Namespaces
path "sys/namespaces" {
  capabilities = ["list"]
}

###############################
#### Key/Value Permissions ####
###############################

# Create, update, read, and delete key/value secrets
# Assumes KV/V2 enabled at secret/ path
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete"]
}

# List and read KV/V2 metadata for key/value secrets
# Assumes KV/V2 enabled at secret/ path
path "secret/metadata/*" {
  capabilities = ["read", "list"]
}