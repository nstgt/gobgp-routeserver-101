#!env bash

script_dir=$(cd $(dirname $BASH_SOURCE); pwd)
root_dir=$script_dir/../
ssh_config=$root_dir/tmp/ssh_config

[ -f $ssh_config ] || vagrant ssh-config > $ssh_config

for host in r1 r2 r3; do
  ssh -F $ssh_config -l root $host "[ -f /var/root/initial_config ] || zcat /config/juniper.conf.gz > /var/root/initial_config"
  ssh -F $ssh_config -l root $host cat /var/root/initial_config > $root_dir/configs/${host}.initial_config
done
