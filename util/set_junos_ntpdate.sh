#!env bash

script_dir=$(cd $(dirname $BASH_SOURCE); pwd)
ssh_config=$script_dir/../tmp/ssh_config

[ -f $ssh_config ] || vagrant ssh-config > $ssh_config

for host in r1 r2 r3; do
  ssh -F $ssh_config -l root $host "cat << EOF | sh
echo '*/10 * * * * echo \"set date ntp 216.239.35.0\" | /usr/sbin/cli' > crontab_ntpdate
crontab crontab_ntpdate
"
done
