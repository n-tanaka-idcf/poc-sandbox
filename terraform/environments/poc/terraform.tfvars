api_url = "https://compute.jp-east.idcfcloud.com/client/api"

zone = "tesla"

network_id = "b1cb5ec4-3860-4bbe-b651-a21f60521e6b"

keypair = "n-tanaka"

instances = {
  "sandbox-misc-01" = {
    service_offering = "standard.S4"
    root_disk_size   = 50
    group            = "sandbox"
  }
  "sandbox-vds-network-01" = {
    service_offering = "highmem.XL64"
    root_disk_size   = 100
    group            = "sandbox-vds"
  }
}

disks = {}

nat_instances = {
  "sandbox-misc-01"        = true
  "sandbox-vds-network-01" = true
}

template = "Rocky Linux 9.6 64-bit"

firewall_rules = {
  "sandbox-misc-01" = {
    cidr_list = [
      "202.230.223.225/32", # Netskope
      "210.140.186.241/32", # Netskope
      "202.230.240.74/32"   # Teana
    ]
    protocol = "tcp"
    ports    = [22]
  },
  "sandbox-vds-network-01" = {
    cidr_list = [
      "202.230.223.225/32", # Netskope
      "210.140.186.241/32", # Netskope
      "202.230.240.74/32"   # Teana
    ]
    protocol = "tcp"
    ports    = [22, 443]
  }
}
