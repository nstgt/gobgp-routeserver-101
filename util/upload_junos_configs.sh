#!env bash

script_dir=$(cd $(dirname $BASH_SOURCE); pwd)
ssh_config=$script_dir/../tmp/ssh_config

[ -f $ssh_config ] || vagrant ssh-config > $ssh_config

for host in r1 r2 r3; do
  patch_file=$script_dir/../configs/${host}.patch
  initial_config_file=$script_dir/../config/${host}.initial_config
  scp -F $ssh_config $patch_file root@${host}:${host}.patch
  scp -F $ssh_config $initial_config_file root@${host}:initial_config
done

for host in r1 r2 r3; do
  ssh -F $ssh_config -l root $host "cat << EOF | cli
configure
load override initial_config
load patch ${host}.patch
show | compare
commit
exit
EOF
"
done
