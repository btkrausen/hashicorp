def get_token(vserv):
 
    vtoken = vault_call(vserv, "login")

    if not re.match(r"(^s.{25}$)", vtoken):
        return False
    else:
        cluster_token.update({vserv: vtoken})

    with open("tokens_mem", "w+") as fh_:
        json.dump(cluster_token, fh_)

    return True
