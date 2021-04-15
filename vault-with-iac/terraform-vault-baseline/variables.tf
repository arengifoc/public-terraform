variable "vault_token" {
  description = "Toot token used to connect to Vault for terraform deployment"
}

variable "ldap_auth_path" {
  default     = "ldap"
  description = "Default path for LDAP auth method"
}

variable "ldap_auth_groupfilter" {
  default     = "(&(objectClass=person)(sAMAccountName={{.Username}}))"
  description = "AD filter used by Vault to filter member of AD groups. No need to touch this"
}

variable "ldap_auth_groupattr" {
  default     = "memberOf"
  description = "Default attribute used to identify group membership. No need to touch this"
}

variable "ldap_auth_userattr" {
  default     = "sAMAccountName"
  description = "Default attribute used to identify AD users. No need to touch this"
}

variable "ldap_auth_starttls" {
  default     = false
  description = "Whether to use STARTTLS when connecting to AD DC"
}

variable "ldap_auth_insecure_tls" {
  default     = true
  description = "Whether to use an unverified TLS connection to the AD DC or not"
}

variable "ldap_auth_certificate" {
  default     = null
  description = "If AD DC requires TLS, this must contain the root/intermediate certificate that signed the AD certificate"
}

variable "approle_auth_path" {
  default     = "approle"
  description = "Default path for AppRole auth method"
}

variable "jenkins_role" {
  default     = "jenkins_role"
  description = "AppRole role name created for an example Jenkins app"
}

variable "jenkins_path" {
  default     = "jenkins"
  description = "KV path to create as an example"
}

variable "remote_state_bucket" {
  description = "S3 key referenced by the S3 backend of terraform-infra-vault"
}

variable "remote_state_key" {
  description = "S3 key referenced by the S3 backend of terraform-infra-vault"
}

variable "remote_state_region" {
  description = "AWS region referenced by the S3 backend of terraform-infra-vault"
}
