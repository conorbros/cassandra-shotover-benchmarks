#!/bin/bash

NODE_ADDRESS="${1}"
cassandra-stress write -mode native cql3 user=cassandra password=cassandra -node $NODE_ADDRESS
