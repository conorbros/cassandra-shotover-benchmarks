ADDRESS="${1}"

./run_benches.sh $ADDRESS 40000 120s 1
./run_benches.sh $ADDRESS 150000 120s 1
./run_benches.sh $ADDRESS 300000 120s 1

./run_benches.sh $ADDRESS 40000 120s 128
./run_benches.sh $ADDRESS 150000 120s 128
./run_benches.sh $ADDRESS 300000 120s 128
