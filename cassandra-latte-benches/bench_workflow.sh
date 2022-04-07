ADDRESS="${1}"

./run_benches.sh $ADDRESS 200 600s 1
./run_benches.sh $ADDRESS 500 600s 1
./run_benches.sh $ADDRESS 1000 600s 1
./run_benches.sh $ADDRESS 5000 600s 1

./run_benches.sh $ADDRESS 200 600s 16
./run_benches.sh $ADDRESS 500 600s 16
./run_benches.sh $ADDRESS 1000 600s 16
./run_benches.sh $ADDRESS 5000 600s 16

./run_benches.sh $ADDRESS 200 600s 32
./run_benches.sh $ADDRESS 500 600s 32
./run_benches.sh $ADDRESS 1000 600s 32
./run_benches.sh $ADDRESS 5000 600s 32

./run_benches.sh $ADDRESS 200 600s 64
./run_benches.sh $ADDRESS 500 600s 64
./run_benches.sh $ADDRESS 1000 600s 64
./run_benches.sh $ADDRESS 5000 600s 64

./run_benches.sh $ADDRESS 200 600s 128
./run_benches.sh $ADDRESS 500 600s 128
./run_benches.sh $ADDRESS 1000 600s 128
./run_benches.sh $ADDRESS 5000 600s 128

./run_benches.sh $ADDRESS 200 600s 256
./run_benches.sh $ADDRESS 500 600s 256
./run_benches.sh $ADDRESS 1000 600s 256
./run_benches.sh $ADDRESS 5000 600s 256
