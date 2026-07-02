number=$(($(wc -l < cp_node_list) - 1))

for i in `seq 0 $number`
do
	kubectl config use-context cluster$i
	echo cluster$i
	kubectl get pod -A --field-selector=status.phase!=Running
done

echo "screen -S mysession"