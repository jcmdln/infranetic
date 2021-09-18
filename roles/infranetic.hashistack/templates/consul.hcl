# {{ template_destpath }}
# {{ ansible_managed }}

advertise_addr = "{{ consul_advertise_addr }}"
bind_addr = "{{ consul_bind_addr }}"
bootstrap_expect = {{ consul_bootstrap_expect }}
client_addr = "{{ consul_client_addr }}"
data_dir = "{{ consul_data_dir }}"
server = {{ consul_server|lower }}

ui_config {
    enabled = {{ consul_ui_config_enabled|lower }}
}
