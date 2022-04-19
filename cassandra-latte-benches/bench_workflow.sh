ADDRESS="${1}"

./run_benches.sh $ADDRESS 200 120s 1
./run_benches.sh $ADDRESS 500 120s 1
./run_benches.sh $ADDRESS 1000 120s 1
./run_benches.sh $ADDRESS 5000 120s 1

./run_benches.sh $ADDRESS 200 120s 64
./run_benches.sh $ADDRESS 500 120s 64
./run_benches.sh $ADDRESS 1000 120s 64
./run_benches.sh $ADDRESS 5000 120s 64

./run_benches.sh $ADDRESS 200 120s 128
./run_benches.sh $ADDRESS 500 120s 128
./run_benches.sh $ADDRESS 1000 120s 128
./run_benches.sh $ADDRESS 5000 120s 128
