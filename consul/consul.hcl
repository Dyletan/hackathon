data_dir = "/opt/consul"
bind_addr = "0.0.0.0"

server {
  bootstrap_expect = 1
}

client {
  enabled = true
}

dns_config {
  recursor_timeout = "5s"
  enable_truncate = true
}
domain = "kbtu.nb"
