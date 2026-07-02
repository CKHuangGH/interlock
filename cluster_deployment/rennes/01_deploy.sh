#!/bin/bash
set -e

mkdir -p logs

echo "Reserving resources..."
python3 ./script/server.py

echo "Reservation finished. Starting VM installation..."

pids=()

python3 ./script/vm-management-cluster.py

sleep 5

python3 ./script/vm-member-cluster-1.py &
pids+=($!)

python3 ./script/vm-member-cluster-2.py &
pids+=($!)

python3 ./script/vm-member-cluster-3.py &
pids+=($!)

python3 ./script/vm-member-cluster-4.py &
pids+=($!)

python3 ./script/vm-member-cluster-5.py &
pids+=($!)

echo "Waiting for all VM installation scripts..."

for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All VM scripts finished. Waiting 45 seconds for system stabilization..."

total=45
for ((elapsed=0; elapsed<=total; elapsed++)); do
    remaining=$((total - elapsed))
    percent=$((elapsed * 100 / total))
    filled=$((percent / 2))
    empty=$((50 - filled))

    bar=$(printf "%${filled}s" | tr ' ' '#')
    space=$(printf "%${empty}s")

    printf "\r[%s%s] %3d%% | %3d sec remaining" "$bar" "$space" "$percent" "$remaining"
    sleep 1
done
. ./02_system_ready.sh