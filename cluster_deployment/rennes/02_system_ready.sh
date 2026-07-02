#!/bin/bash

manage=$(awk NR==1 node_list)

git clone https://github.com/CKHuangGH/dampscale
rm -rf /home/chuang/.ssh/known_hosts

for j in $(cat node_list)
do
    scp /home/chuang/.ssh/id_rsa root@$j:/root/.ssh
    scp -r ./dampscale root@$j:/root/
done

echo "wait for 30 secs"
sleep 30

i=0
for j in $(cat node_list)
do
ssh -o StrictHostKeyChecking=no root@$j scp -o StrictHostKeyChecking=no /root/.kube/config root@$manage:/root/.kube/cluster$i
ssh -o StrictHostKeyChecking=no root@$j chmod 777 -R /root/dampscale/
i=$((i+1))
done

scp node_list root@$manage:/root/dampscale/package/node_list
scp node_ip_all root@$manage:/root/dampscale/package/node_ip_all

echo "management node is $manage"