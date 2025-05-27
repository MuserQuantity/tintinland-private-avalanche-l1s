#!/bin/bash
unset HTTP_PROXY
unset HTTPS_PROXY
unset http_proxy
unset https_proxy
# 启动网络
# 如果存在/root/.avalanche-cli/snapshots/local_primary_snapshot/，则使用ocal_primary_snapshot
# 否则先start，stop后保存，再启动
if [ -d "/root/.avalanche-cli/snapshots/local_primary_snapshot/" ]; then
    echo "本地快照local_primary_snapshot存在"
    ./avalanche network start --config network-config.json --snapshot-name=local_primary_snapshot
else
    echo "本地快照local_primary_snapshot不存在"
    ./avalanche network start --config network-config.json
    ./avalanche network stop --config network-config.json --snapshot-name=local_primary_snapshot
    echo "本地快照local_primary_snapshot已保存"
    ./avalanche network start --config network-config.json --snapshot-name=local_primary_snapshot
fi