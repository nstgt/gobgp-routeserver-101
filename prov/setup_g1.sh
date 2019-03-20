apt-get update

# install quagga
apt-get -y install quagga-core/stretch quagga-ospfd/stretch libncursesw5/stretch libncurses5/stretch libtinfo5/stretch

cp /vagrant/configs/g1/zebra.conf /etc/quagga
cp /vagrant/configs/g1/ospfd.conf /etc/quagga
touch /etc/quagga/vtysh.conf

systemctl enable zebra
systemctl enable ospfd
systemctl restart zebra
systemctl restart ospfd

echo "1" > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

sed -i -e 's/User=gobgpd/User=quagga/g' /etc/systemd/system/gobgpd.service
systemctl daemon-reload
