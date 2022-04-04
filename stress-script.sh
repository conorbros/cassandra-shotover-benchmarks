#!/bin/bash

NODE_ADDRESS="${1}"
PORT="${2}"

cassandra-stress write -mode native cql3 user=cassandra password=cassandra -node $NODE_ADDRESS -port native $PORT
cassandra-stress read -mode native cql3 user=cassandra password=cassandra -node $NODE_ADDRESS -port native=$PORT
