# GoBGP version to install
export GOBGP_VER=2.2.0

# install GoBGP
mkdir -p /usr/local/sbin
TMPDIR=$(mktemp -d)
(
  cd ${TMPDIR}
  wget -q https://github.com/osrg/gobgp/releases/download/v${GOBGP_VER}/gobgp_${GOBGP_VER}_linux_amd64.tar.gz
  tar zxvf gobgp_${GOBGP_VER}_linux_amd64.tar.gz
  cp gobgp gobgpd /usr/local/sbin
)
rm -Rf ${TMPDIR}

# install bash completions for gobgp command
wget -q -P /etc/bash_completion.d https://raw.githubusercontent.com/osrg/gobgp/v${GOBGP_VER}/tools/completion/gobgp-completion.bash
wget -q -P /etc/bash_completion.d https://raw.githubusercontent.com/osrg/gobgp/v${GOBGP_VER}/tools/completion/gobgp-dynamic-completion.bash
wget -q -P /etc/bash_completion.d https://raw.githubusercontent.com/osrg/gobgp/v${GOBGP_VER}/tools/completion/gobgp-static-completion.bash

# install libcap2-bin (for setcap used in systemd unit file)
apt-get install -y libcap2-bin

id gobgpd || useradd -r gobgpd
mkdir -p /etc/gobgp
cp /vagrant/prov/gobgpd.service /etc/systemd/system
systemctl daemon-reload

# configure logging
cp /vagrant/prov/rsyslog.d/gobgpd.conf /etc/rsyslog.d/gobgpd.conf
systemctl restart rsyslog

# configure logrotation
cp /vagrant/prov/logrotate.d/gobgpd.conf /etc/logrotate.d/gobgpd.cond
