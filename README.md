# Infrastructure Setup for Running Cassandra w/ Shotover Request throttling benches

# Deploy to AWS

## Build Packer images

Run following commands in the `packer` dir

```console
packer build apache-cassandra
packer build benchmark_runner
```

## Apply Terraform

Create an ssh key and name it `.ssh/aws_key`.

Run `terraform apply -auto-approve` in the `example/examplea` dir:

# Run benches

### ssh into benchmark runner machine

`ssh -i .ssh/aws_key ec2-user@${IP}`.

Run `bench_workflow.sh` in `cassandra-latte-benches`.

Use scp to transfer results to local machine.

TODO add instructions for cassandra-stress

# Profile Shotover

ssh into one of the Cassandra node machines.

Install the required tools and recompile Shotover with debug symbols enabled.

`setup_perf_tools.sh`.

Replace the Shotover binary and restart the service.

`replace_shotover_bin.sh`.

Start recording perf data.

`sudo perf record --call-graph dwarf -p $(pgrep shotover)`.

Run desired benchmarks from the BenchmarkRunner machine.

 Return to Cassandra machine, stop the `perf record` process and then use `sudo perf script | inferno-collapse-perf | inferno-flamegraph > perf.svg` to generate a flamegraph.

Use scp to transfer flamegraph to local machine
