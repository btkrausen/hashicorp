import simplejson as json
import yaml
from jinja2 import Template

stream = file('/etc/vault.d/setup/vars.yml', 'r')
template_vars = yaml.load(stream)

stream = file('/etc/vault.d/setup/peer_nodes.json', 'r')
template_vars["vault_node_ids"] = json.load(stream)

template = Template("""
ui = true

storage "raft" {
  path    = "/var/lib/vault"
  node_id = "{{ vault_node_id }}"
  {% for peer_node_id in vault_node_ids %}
  retry_join = {
    leader_api_addr = "https://{{ peer_node_id }}.{{ vault_domain }}:{{ vault_api_port }}"
    {% if vault_tls_ca_filename -%}
    leader_ca_cert_file = "{{ vault_tls_path }}/{{ vault_tls_ca_filename }}"
    {% endif -%}
  }
  {%- endfor %}
}

seal "awskms" {
  region     = "{{ aws_region }}"
  kms_key_id = "{{ vault_kms_key_id }}"
}

listener "tcp" {
  address       = "{{ vault_node_id }}.{{ vault_domain }}:{{ vault_api_port }}"
  tls_cert_file = "{{ vault_tls_path }}/{{ vault_tls_cert_filename }}"
  tls_key_file  = "{{ vault_tls_path }}/{{ vault_tls_key_filename }}"
}

api_addr     = "https://{{ vault_node_id }}.{{ vault_domain }}:{{ vault_api_port }}"
cluster_addr = "https://{{ vault_node_id }}.{{ vault_domain }}:{{ vault_cluster_port }}"
""")

with open("/etc/vault.d/vault.hcl", "w") as config:
  print >> config, template.render(template_vars)
