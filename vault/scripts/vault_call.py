def vault_call(vserv, vact):

    crl = pycurl.Curl()
    data = BytesIO()
    base_url = "https://" + vserv + ":8200/v1/"

    if vact == "login":
        vault_url = base_url + "auth/approle/login"
        role_id = os.environ.get("ROLE_ID")
        sec_id = os.environ.get("SEC_ID")
        login_data = json.dumps({"role_id": role_id, "secret_id": sec_id})
        crl.setopt(crl.POSTFIELDS, login_data)
    elif vact == "get":
        vault_url = base_url + "secrets/data/myapp"
        vault_header = ["X-Vault-Token: " + cluster_token[vserv]]
        crl.setopt(crl.HTTPHEADER, vault_header)
    else:
        print("Invalid Option")
        exit()
 
    crl.setopt(crl.URL, vault_url)
    crl.setopt(crl.WRITEFUNCTION, data.write)
 
    try:
        crl.perform()
        resp_data = json.loads(data.getvalue())
        resp_code = crl.getinfo(pycurl.RESPONSE_CODE)
    except pycurl.error:
        crl.close()
        return "Connection Failed"
 
    crl.close()
 
    if resp_code != 200:
        return resp_code
    elif vact == "login":
        return resp_data["auth"]["client_token"]
    elif vact == "get":
        return resp_data["data"]["data"]
    else:
        return resp_data
