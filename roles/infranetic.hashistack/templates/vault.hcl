# {{ template_destpath }}
# {{ ansible_managed }}

api_addr = "https://{{ vault_listener_address }}"
cluster_addr = "https://{{ vault_cluster_address }}"
ui = false

# https://www.vaultproject.io/docs/configuration/listener
listener "tcp" {
    address = "{{ vault_listener_address }}"
    tls_cert_file = "/opt/vault/tls/tls.crt"
    tls_key_file = "/opt/vault/tls/tls.key"
    tls_min_version = "tls12"
}

# https://www.vaultproject.io/docs/configuration/storage
storage "consul" {
    address = "{{ vault_storage_address }}"
    path = "{{ vault_storage_path }}"
}

# https://www.vaultproject.io/docs/configuration/telemetry
telemetry {
    statsite_address = "{{ vault_telemetry_address }}"
    disable_hostname = {{ vault_telemetry_disable_hostname|lower }}
}

vault {
    address = "https://{{ vault_listener_address }}"
    client_cert = "/opt/vault/tls/tls.crt"
    client_key = "/opt/vault/tls/tls.key"
}
