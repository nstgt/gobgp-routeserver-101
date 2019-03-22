#!env bash

script_dir=$(cd $(dirname $BASH_SOURCE); pwd)
ssh_config=$script_dir/../tmp/ssh_config

[ -f $ssh_config ] || vagrant ssh-config > $ssh_config

for host in r1 r2 r3; do
  patch_file=$script_dir/../configs/${host}.patch
  scp -F $ssh_config $patch_file root@${host}:${host}.patch
done

for host in r1 r2 r3; do
  ssh -F $ssh_config -l root $host "cat << EOF | cli
configure
load patch ${host}.patch
show | compare
commit
exit
EOF
"
done
