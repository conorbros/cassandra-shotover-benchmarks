module "cassandra" {
  source        = "../../"
  instance_type = "i3en.xlarge"
  subnet_ids    = data.aws_subnet_ids.subs.ids
  #add the private ips
  private_ips       = local.private_ips
  allowed_ranges    = ["0.0.0.0/0"]
  ssh-inbound-range = ["0.0.0.0/0"]
  ami               = local.ami
  vpc_id            = tolist(data.aws_vpcs.main.ids)[0]
}


module "myip" {
  source  = "jameswoolfenden/ip/http"
  version = "0.2.7"
}

locals {
  private_ips = [cidrhost(data.aws_subnet.a.cidr_block, 14), cidrhost(data.aws_subnet.a.cidr_block, 15), cidrhost(data.aws_subnet.a.cidr_block, 16)]
}
