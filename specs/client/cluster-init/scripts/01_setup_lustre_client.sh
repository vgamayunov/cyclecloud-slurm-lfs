#!/bin/bash

# set up cycle vars
yum -y install jq
cluster_name=$(jetpack config cyclecloud.cluster.name)
ccuser=$(jetpack config cyclecloud.config.username)
ccpass=$(jetpack config cyclecloud.config.password)
ccurl=$(jetpack config cyclecloud.config.web_server)

lustre_name=$(jetpack config lustre.client.cluster_name)
mount_point=$(jetpack config lustre.client.mount_point)

mds_ip=$(curl -s -k --user $ccuser:$ccpass "$ccurl/clusters/$lustre_name/nodes"| jq -r '.nodes[] | select(.Template=="mds") | .IpAddress')

script_dir=$CYCLECLOUD_SPEC_PATH/files
chmod +x $script_dir/*.sh

# SETUP LUSTRE YUM REPO
$script_dir/lfsrepo.sh

$script_dir/lfsclient.sh $mds_ip $mount_point