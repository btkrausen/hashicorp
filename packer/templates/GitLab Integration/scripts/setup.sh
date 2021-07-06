#!/usr/bin/env bash
set -euxo pipefail

export VAULT_ARCHIVE="vault_${VAULT_VERSION}_linux_arm64.zip"

echo "Installing jq"
sudo yum install jq -y

echo "Configuring system time"
sudo timedatectl set-timezone UTC

echo "Installing Vault Enterpise"
curl --silent -Lo /tmp/${VAULT_ARCHIVE} https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ARCHIVE}
sudo unzip -d /usr/local/bin /tmp/${VAULT_ARCHIVE}

echo "Adding Vault system users"

create_ids() {
  sudo /usr/sbin/groupadd --force --system ${1}
  if ! getent passwd ${1} >/dev/null ; then
    sudo /usr/sbin/adduser \
      --system \
      --gid ${1} \
      --home /srv/${1} \
      --no-create-home \
      --comment "${1} account" \
      --shell /bin/false \
      ${1}  >/dev/null
  fi
}

create_ids vault

echo "Configuring HashiCorp directories"
# Second argument specifies user/group for chown, as consul-snapshot does not have a corresponding user
directory_setup() {
  # create and manage permissions on directories
  sudo mkdir -pm 0750 /etc/${1}.d /var/lib/${1} /var/lib/${1}/data
  sudo mkdir -pm 0700 /etc/${1}.d/tls /etc/${1}.d/setup
  sudo chown -R ${2}:${2} /etc/${1}.d /var/lib/${1}
}

directory_setup vault vault

echo "Copy systemd services"

systemd_files() {
  sudo cp /tmp/files/$1 /etc/systemd/system
  sudo chmod 0664 /etc/systemd/system/$1
}

systemd_files vault.service 
