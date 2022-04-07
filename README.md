# Infrastructure Setup for Running Cassandra w/ Shotover Request throttling benches

# Deploy to AWS

## Build Packer images

Run following commands in the `packer` dir

```console
packer build apache-cassandra
packer build benchmark_runner
```

## Apply Terraform

1. Create an ssh key and put it in `.ssh/aws_key`.

2. Run following commands in the `example/examplea` dir: `terraform apply -auto-approve`

# Run benches

### ssh into benchmark runner machine

`ssh -i .ssh/aws_key ec2-user@${IP}`.

Run `bench_workflow.sh` in `cassandra-latte-benches`.

TODO add instructions for cassandra-stress

# Profile Shotover

1. ssh into one of the Cassandra node machines.

2. `setup_perf_tools.sh`.

3. `sudo perf record --call-graph dwarf -p $(pgrep shotover)`.

4. Run desired benchmarks from the BenchmarkRunner machine.

5. Return to Cassandra machine, stop the `perf record` process and then use `` to generate a flamegraph.

6. Use scp to transfer flamegraph to local machine
