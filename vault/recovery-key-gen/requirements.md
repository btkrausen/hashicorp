## Recovery Key Recovery Tool Requirements
If you've lost the recover keys for your cluster, you can use the Vault Recovery Key tool as an attempt to regenerate keys for the cluster. Once generated, I'd recommend using the official Vault CLI command ```vault operator rekey``` to regenerate them again. 

https://github.com/jdfriedma/vault-recovery-key

_Note that the link above is a fork from the original tool, but the repo above includes additional functionality not found in the original repo_

The tool can be run directly on an existing Vault/Consul cluster node if the current auto unseal mechanism is supported by the tool. Deployment of a new "DR" cluster using a supported auto unseal mechanism can be used if the current cluster is using an auto unseal configuration not supported by the tool. This, of course, assumes that you are running Vault Enterprise and can configure DR replication. If not, you'll have to migrate the existing auto unseal configuration to a supported configuration.

### High-Level Steps for Recovery
1. Deploy a new single-node Vault "cluster" that will be configured for DR replication. Use Consul as the backend using a new single-node Consul cluster. Both of these will be destroyed after so minimal configuration can be used.
2. Configure the new Vault cluster to use an existing cluster for ```transit``` auto unseal. 
3. Initialize and unseal the new cluster
4. Generate a DR secondary token on the primary cluster for replication
5. Configure DR replication on the new Vault cluster using the secondary token
6. Validate replication is working as expected (waiting for ```stream-wals``` status)
7. Obtain the recovery key from Consul stored on the KV using the command ```consul kv get -base64 vault/core/recovery-key  | base64 -d >  consul.key```
8. Configure all of the required environment variables found at the link above.
9. Run the Vault recovery key tool to generate new keys.
10. Using the new keys, use the ```vault operator rekey``` command to regenerate "official" keys on the primary cluster.
11. Remove the DR cluster from replication on the primary cluster.
12. Destroy the new Vault and Consul nodes.

### Network Requirements

* Bi-directional communication between primary cluster (target) and the new node/cluster used for recovery over ports ```tcp/8200``` and ```tcp/8201```
* Communication between the Vault and Consul nodes (newly deployed resources)
* TLS certificate (if needed for replication)

### Preparation

**Install Golang**
```
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```

**Install Git**

```sudo yum install git```

**Create Directory and Clone Repo on Host**
```
cd /tmp
cd /tmp/vrc
git clone https://github.com/jdfriedma/vault-recovery-key.git
```

**Create binary directory and package recovery key tool**
```
mkdir bin
GOOS=linux GOARCH=amd64 go build -o bin/vault-recovery-key ./main.go
```

### Recovery Key Execution

**Export Environment Variables for Tool Execution**
```
export VAULT_ADDR="<vault-cluster-address>:8200"
export VAULT_TOKEN="<token from cluster above>"
export VAULT_TRANSIT_SEAL_KEY_NAME="auto-unseal"
export VAULT_TRANSIT_SEAL_MOUNT_PATH="transit"
export VAULT_NAMESPACE="admin"
```

**Obtain the Recovery Key from Consul**
```
export CONSUL_HTTP_TOKEN=<token>
consul kv get -base64 vault/core/recovery-key  | base64 -d >  consul.key
```

Run the Vault recovery key tool to generate keys

```./vault-recover-key -enc-key consul.key -env transit -shamir-shares 5 -shamir-threshold 3```


### Rekey Vault using Official Tool

```vault operator rekey -init -target=recovery -key-shares=5 -key-threshold=3```

Obtain nonce value from output of command above and use for rekey commands below:

```vault operator rekey -nonce=<nonce> -target=recovery```
 - provide key from output of tool
```vault operator rekey -nonce=<nonce> -target=recovery```
 - provide key from output of tool
```vault operator rekey -nonce=<nonce> -target=recovery```
 - provide key from output of tool