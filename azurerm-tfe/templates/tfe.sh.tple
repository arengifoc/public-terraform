#!/bin/bash
declare -A tfe_settings
declare -A replicated_conf

###################################
#### INICIO - SECCION A EDITAR ####
###################################

# Modificar estos valores, segun se crea conveniente
replicated_conf[tlsbootstraphostname]="${tlsbootstraphostname}"
tfe_settings[azure_account_name]="tfecompany"
sas_token="${sas_token}"
tfe_settings[azure_account_key]="JIw2Jbo4G680jCUVInE8PafmKEKihmO8MWVTCMW9AoR5xQHdSdVcYj9TnbxydRIsEw4WKNUWMyFK8K1adLNz6Q=="
settings_container="terraform"
replicated_conf[daemonauthenticationpassword]="YmQ0OWUyMWZi"
tfe_settings[hostname]="tfe.company.global"
tfe_settings[azure_container]="tfevm1"
tfe_settings[extern_vault_addr]="http://10.0.0.5:8200"
tfe_settings[extern_vault_path]="auth/approle"
tfe_settings[extern_vault_role_id]="aa5d06b3-9ab2-7d13-e264-4220f1e10808"
tfe_settings[extern_vault_secret_id]="22c46a73-fcce-8d9b-a323-55f1f3cccbca"
tfe_settings[pg_dbname]="${pg_dbname}"
tfe_settings[pg_netloc]="${pg_netloc}"
tfe_settings[pg_password]="${pg_password}"
tfe_settings[pg_user]="${pg_user}"
tfe_settings[custom_image_tag]="${custom_image_tag}"
tfe_settings[capacity_concurrency]="10"
tfe_settings[capacity_memory]="512"
tfe_settings_file="tfe-settings.json"
replicated_conf_file="replicated.conf"
cert_bundle_filename="cert-bundle.pem"
replicated_conf[tlsbootstrapcert]="wildcard.company.global-cert.pem"
replicated_conf[tlsbootstrapkey]="wildcard.company.global-key.pem"
replicated_conf[licensefilelocation]="tfe-license.rli"
replicated_conf[importsettingsfrom]="$tfe_settings_file"
tfe_settings[backup_token]="eu3KZg1WrP7snxmi08q5d0aeiAABFiA2"
tfe_settings[enc_password]="5a8EcusSnOSaL/YiR2BD8Mces20kz2JSkT8M2mpWZj4="
container_url="https://$${tfe_settings[azure_account_name]}.blob.core.windows.net/$settings_container"

###################################
####   FIN - SECCION A EDITAR  ####
###################################

# systemctl disable firewalld
# systemctl stop firewalld
# yum install -y yum-utils
# yum-config-manager --enable rhel-7-server-extras-rpms
# yum install -y docker
# systemctl enable --now docker
# yum install -y yum-plugin-versionlock
# yum versionlock docker
# sed -i -e '/--authorization-plugin=rhel-push-plugin/d' /usr/lib/systemd/system/docker.service
# systemctl daemon-reload
# systemctl restart docker
# sed -i -e '/^SELINUX=/s/=.*/=disabled/g' /etc/selinux/config
# setenforce 0
docker pull $${tfe_settings[custom_image_tag]}
cd /tmp
wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux
tar -zxf azcopy.tar.gz
cd $(echo azcopy_linux_amd64_* as e | cut -d ' ' -f 1)
install -o root -g root -m 755 azcopy /usr/local/bin
cd /tmp

for file in $tfe_settings_file $replicated_conf_file $cert_bundle_filename $${replicated_conf[tlsbootstrapcert]} $${replicated_conf[tlsbootstrapkey]} $${replicated_conf[licensefilelocation]}
do
  azcopy copy --log-level NONE "$container_url/$${file}$${sas_token}" .
done

for key in "$${!tfe_settings[@]}"
do
  sed -i -e "s|$${key^^}|$${tfe_settings[$key]}|g" $tfe_settings_file
done

sed -i -e "s|CA_CERTS|$(sed -e ':a;N;$!ba;s/\n/\\\\n/g' $cert_bundle_filename)|g" $tfe_settings_file

for key in "$${!replicated_conf[@]}"
do
  sed -i -e "s|$${key^^}|$${replicated_conf[$key]}|g" $replicated_conf_file
done

cp $replicated_conf_file /etc

public_ip=$(curl -s checkip.dyndns.org | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
main_nic=$(ip route show | grep ^default | awk '{ print $5 }')
private_ip=$(ip addr show $main_nic | grep -w inet | cut -d / -f 1 | awk '{ print $2 }')
curl -s -o /tmp/install.sh https://install.terraform.io/ptfe/stable
bash /tmp/install.sh no-docker no-proxy private-address=$private_ip public-address=$public_ip
