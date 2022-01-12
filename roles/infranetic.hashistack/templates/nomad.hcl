# {{ template_destpath }}
# {{ ansible_managed }}

bind_addr = "{{ nomad_bind_addr }}"
data_dir = "{{ nomad_data_dir }}"
plugin_dir = "{{ nomad_plugin_dir }}"

client {
    enabled = {{ nomad_client_enabled|lower }}
    servers = {{ nomad_client_servers }}
}

server {
    enabled = {{ nomad_server_enabled|lower }}
    bootstrap_expect = {{ nomad_server_bootstrap_expect }}
}

vault {
    enabled = {{ nomad_vault_enabled|lower }}
    create_from_role = "{{ nomad_vault_create_from_role }}"

    address = "{{ nomad_vault_address }}"
    ca_path = "{{ nomad_vault_ca_path }}"
    cert_file = "{{ nomad_vault_cert_file }}"
    key_file = "{{ nomad_vault_key_file }}"
}

plugin "nomad-driver-podman" {
    config {
        volumes {
            enabled = {{ nomad_driver_podman_config_volumes_enabled|lower }}
            selinuxlabel = "{{ nomad_driver_podman_config_volumes_selinuxlabel }}"
        }
    }
}