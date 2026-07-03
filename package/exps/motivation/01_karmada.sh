#!/bin/bash

curl -s https://github.com/karmada-io/karmada/releases/download/v1.18.1/kubectl-karmada-linux-amd64.tgz | sudo bash -s kubectl-karmada

tar -xzf /tmp/kubectl-karmada-linux-amd64.tgz -C /tmp

sudo install -m 0755 /tmp/kubectl-karmada /usr/local/bin/kubectl-karmada

kubectl config use-context cluster0

# for i in $(cat node_exec)
# do
#     ssh root@$i kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
# done

kubectl karmada init

for i in range(10, 0, -1):
    print(f"\rCountdown: {i} seconds", end="", flush=True)
    time.sleep(1)

cluster=1
for i in $(cat cp_node_list_without_management)
do
    kubectl karmada --kubeconfig /etc/karmada/karmada-apiserver.config  join cluster$cluster --cluster-kubeconfig=$HOME/.kube/cluster$cluster
	cluster=$((cluster+1))
done