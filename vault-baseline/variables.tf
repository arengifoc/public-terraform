variable "vault_token" {}
variable "approle_auth_path" { default = "approle" }
variable "ldap_auth_path" { default = "ldap" }
# variable "ldap_auth_url" {}
# variable "ldap_auth_binddn" {}
# variable "ldap_auth_bindpass" {}
variable "ldap_auth_userattr" { default = "sAMAccountName" }
variable "ldap_auth_userdn" {}
variable "ldap_auth_groupdn" {}
variable "ldap_auth_groupfilter" { default = "(&(objectClass=person)(sAMAccountName={{.Username}}))" }
variable "ldap_auth_groupattr" { default = "memberOf" }
variable "ldap_auth_starttls" { default = false }
variable "ldap_auth_insecure_tls" { default = true }
variable "ldap_auth_certificate" { default = null }

variable "jenkins_role" { default = "jenkins_role" }
variable "jenkins_path" { default = "jenkins" }
