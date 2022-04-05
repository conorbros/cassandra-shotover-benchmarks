
ADDRESS="${1}"

RATE="${2}"

TIME="${3}"

CONNECTIONS="${4}"

cargo run --release -- -c ${CONNECTIONS} -d ${ADDRESS} -r ${RATE} -s ${ADDRESS} -t ${3}
