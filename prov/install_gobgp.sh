# go version to install
export GO_VERSION=1.12.1

# set envvars for go
cat << EOF > /etc/profile.d/golang.sh
export GOROOT=/usr/local/go
export GOPATH=/usr/local/opt/gopath
export PATH=\$GOROOT/bin:\$PATH
export GO111MODULE=on
EOF

source /etc/profile.d/golang.sh

# install go
mkdir -p $GOPATH
mkdir -p $GOROOT
cd $GOROOT/..
wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz > /dev/null 2>&1
tar zxf go${GO_VERSION}.linux-amd64.tar.gz

# install gobgp and gobgpd
# '/root' is replacable anywhere you prefer
export ROOT=/root
cd $ROOT
git clone git://github.com/osrg/gobgp
cd $ROOT/gobgp && go mod download
cd $ROOT/gobgp/cmd && go install ./...
cp $GOPATH/bin/* /usr/local/sbin

# install bash completions for gobgp command
cp $ROOT/gobgp/tools/completion/*.bash /etc/bash_completion.d/

# install libcap2-bin (for setcap used in systemd unit file)
apt-get install -y libcap2-bin

# configure something related to gobgp
id gobgpd || useradd -r gobgpd
mkdir -p /etc/gobgp
cp /vagrant/prov/gobgpd.service /etc/systemd/system
systemctl daemon-reload

# configure logging
cp /vagrant/prov/rsyslog.d/gobgpd.conf /etc/rsyslog.d/gobgpd.conf
systemctl restart rsyslog

# configure logrotation
cp /vagrant/prov/logrotate.d/gobgpd.conf /etc/logrotate.d/gobgpd.cond
