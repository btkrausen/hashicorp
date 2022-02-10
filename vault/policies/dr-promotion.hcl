### dr-secondary-promotion Vault policy

# To promote a DR cluster to a DR primary
path "sys/replication/dr/secondary/promote" {
  capabilities = [ "update" ]
}

# To update which primary cluster to point to for replication
path "sys/replication/dr/secondary/update-primary" {
    capabilities = [ "update" ]
}

### Next two endpoints only required with Raft storage ###

# To read the current autopilot status
path "sys/storage/raft/autopilot/state" {
    capabilities = [ "update" , "read" ]
}

# To remove a vault node from the raft cluster if using immutable upgrades
path "/sys/storage/raft/remove-peer" {
    capabilities = [ "create", "update" ]
}
