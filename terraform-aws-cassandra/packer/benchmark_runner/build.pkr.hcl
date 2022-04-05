build {
  sources = [
    "source.amazon-ebs.benchmark_runner"
  ]

  provisioner "shell" {
    script  = "${path.root}/install.sh"
    timeout = "18000s"
  }
}
