cluster_tokens = {}
vault_clusters = ["vault-east", "vault-west"]
 
def get_secret():
 
    global cluster_tokens
 
    with open("tokens_mem", "r") as fh_:
        cluster_tokens = json.load(fh_)
 
    for vserv in vault_clusters:
        if vserv not in cluster_tokens:
            if not get_token(vserv):
                if vserv != vault_clusters[-1]:
                    continue
                else:
                    return "Unable to Retrieve Token"
            else:
                break
        else:
            break
 
    for vserv in vault_clusters:
        if vserv in cluster_tokens:
            secret = vault_call(vserv, "get")
        else:
            continue
 
        if secret == "Connection Failed":
            if vserv != vault_clusters[-1]:
                continue
            else:
                return "Unable to Retrieve Secret"
        elif secret == 403:
            if get_token(vserv):
                secret = vault_call(vserv, "get")
                break
            else:
                continue
        elif secret == 404:
            continue
        else:
            break
 
    return secret
