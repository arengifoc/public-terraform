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
