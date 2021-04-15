#!/bin/bash

cat <<EOF | base64 -d > /tmp/${tfe_cert_filename}
${base64encode(file("${path_module}/files/${tfe_cert_filename}"))}
EOF

cat <<EOF | base64 -d > /tmp/${tfe_key_filename}
${base64encode(file("${path_module}/files/${tfe_key_filename}"))}
EOF

cat <<EOF | base64 -d > /tmp/${tfe_license_filename}
${filebase64("${path_module}/files/${tfe_license_filename}")}
EOF

cat <<EOF | base64 -d > /tmp/${tfe_settings_filename}
${base64encode(file("${path_module}/files/${tfe_settings_filename}"))}
EOF

cat <<EOF > /etc/replicated.conf
{
    "TlsBootstrapType":             "server-path",
    "TlsBootstrapHostname":         "${tfe_hostname}",
    "TlsBootstrapCert":             "/tmp/${tfe_cert_filename}",
    "TlsBootstrapKey":              "/tmp/${tfe_key_filename}",
    "LicenseFileLocation":          "/tmp/${tfe_license_filename}",
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "${tfe_console_pass}",
    "BypassPreflightChecks":        true,
    "ImportSettingsFrom":           "/tmp/${tfe_settings_filename}"
}
EOF

public_ip=$(curl -s checkip.dyndns.org | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
main_nic=$(ip route show | grep ^default | awk '{ print $5 }')
private_ip=$(ip addr show $main_nic | grep -w inet | cut -d / -f 1 | awk '{ print $2 }')
curl -o /tmp/install.sh https://install.terraform.io/ptfe/stable
bash /tmp/install.sh no-docker no-proxy private-address=$private_ip public-address=$public_ip