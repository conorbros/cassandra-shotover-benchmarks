#!/bin/bash

set -e

ADDRESS=${1}
CONNECTIONS=${2}

latte schema --user cassandra --password cassandra read.rn -- ${ADDRESS}
latte load --user cassandra --password cassandra read.rn -- ${ADDRESS}
latte run --user cassandra --password cassandra read.rn --connections ${CONNECTIONS} -- ${ADDRESS}
