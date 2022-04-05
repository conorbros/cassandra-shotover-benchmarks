resource "aws_instance" "cassandra" {
  # checkov:skip=CKV2_AWS_17: invalid check
  count         = length(var.private_ips)
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  monitoring    = true
  private_ip    = var.private_ips[count.index]
  ebs_optimized = true

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = false
    encrypted             = true
  }

  vpc_security_group_ids = [aws_security_group.cassandra.id]
  subnet_id              = var.subnet_ids[0]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<HERE
#!/bin/bash
read -d '' CONTENT << EOF
${templatefile("${path.module}/template/cassandra.tmpl", { private_ip = var.private_ips[count.index], seeds = "${var.private_ips[0]},${var.private_ips[2]}" })}
EOF
sudo echo "$CONTENT" > /etc/cassandra/conf/cassandra.yaml

yum update -y
systemctl enable cassandra
service cassandra start

wget https://raw.githubusercontent.com/conorbros/cassandra-shotover-benchmarks/master/topology.yaml
sudo mv topology.yaml /etc/shotover/config/

sudo systemctl start shotover
HERE

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }
}

resource "aws_key_pair" "benchmark_runner_key" {
  key_name   = "benchmark_runner_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMYhMWMVxYcFDjBBC/oURNNk5VUrIgRuV+cEIVGgl+jAVrTJnvHRzr0zixZzkoYU5jDUPL4W61dDT8SGyaYR57MybltWwFcAX+SNLVq5Yia2KjpQ23KSLG1Gh/9Xzz6NlPp0i/GE6PPIrAwma1gOXr5Eh0+oFU6hyS/RD6aNqglOery5CVs80pauONN7Knl0saLI2S+r8a9mJT04fdy3jxImxf+DyphpiUniGMqmBYk0P44LNr+y8x1xnk5J8TpfHyPv5LTS9PFMzNLeFOeqxhKUACzpQjbho05gXykWQ15/j6ZmmIDT8v8S6h/xWxpgOuodQUZsGDzxRajQgUxWrz conor@instaclustr"
}

resource "aws_instance" "benchmark_runner" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.cassandra.id]
  key_name               = "benchmark_runner_key"

  tags = {
    Name = "BenchmarkRunner"
  }

  user_data = <<HERE
#!/bin/bash
su -u ec2-user
cd /home/ec2-user
sudo -u ec2-user git clone https://github.com/conorbros/cassandra-shotover-benchmarks
mv cassandra-shotover-benchmarks/cassandra-latte-benches/ .
mv cassandra-shotover-benchmarks/stress-script.sh .
sudo rm -r cassandra-shotover-benchmarks
EOF
HERE

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/home/conor/.ssh/keys/aws")
    timeout     = "4m"
  }
}
