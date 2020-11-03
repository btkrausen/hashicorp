cluster_token = {}

def get_secret():

    global cluster_token

    with open("tokens_mem", "r") as fh_:
        cluster_token = json.load(fh_)

    if "vault-east" not in cluster_token:
        if not get_token("vault-east"):
            return "Unable to Retrieve Token"

    secret = vault_call("vault-east", "get")
 
    if secret == "Connection Failed":
        return "Unable to Retrieve Secret"
    elif secret == 403:
        if get_token("vault-east"):
            secret = vault_call("vault-east", "get")
        else:
            return "Unable to Retrieve Secret"
    elif secret == 404:
        return "Empty Secret"

    return secret
