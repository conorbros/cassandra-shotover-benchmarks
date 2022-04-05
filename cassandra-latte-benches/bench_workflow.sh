ADDRESS="${1}"


./run_benches.sh $ADDRESS 50000 120s 128
./run_benches.sh $ADDRESS 150000 120s 128
./run_benches.sh $ADDRESS 300000 120s 128
./run_benches.sh $ADDRESS 600000 120s 128

./run_benches.sh $ADDRESS 50000 120s 64
./run_benches.sh $ADDRESS 150000 120s 64
./run_benches.sh $ADDRESS 300000 180s 64
./run_benches.sh $ADDRESS 600000 180s 64

./run_benches.sh $ADDRESS 50000 120s 32
./run_benches.sh $ADDRESS 150000 120s 32
./run_benches.sh $ADDRESS 300000 120s 32
./run_benches.sh $ADDRESS 600000 120s 32

./run_benches.sh $ADDRESS 50000 120s 16
./run_benches.sh $ADDRESS 150000 120s 16
./run_benches.sh $ADDRESS 300000 120s 16
./run_benches.sh $ADDRESS 600000 120s 16

./run_benches.sh $ADDRESS 50000 120s 1
./run_benches.sh $ADDRESS 150000 120s 1
./run_benches.sh $ADDRESS 300000 120s 1
./run_benches.sh $ADDRESS 600000 120s 1
