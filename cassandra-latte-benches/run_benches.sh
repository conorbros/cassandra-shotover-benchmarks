
ADDRESS="${1}"

cargo run --release -- -c 128 -d ${ADDRESS} -r 130000 -s ${ADDRESS} -t 60s
