resource "cloudstack_instance" "instance" {
  for_each         = var.instances
  name             = each.key
  service_offering = each.value.service_offering
  group            = each.value.group
  template         = var.template
  zone             = var.zone
  network_id       = var.network_id
  keypair          = var.keypair
  root_disk_size   = each.value.root_disk_size
  expunge          = true
}

locals {
  disk_map = flatten([
    for vm_name, disks in var.disks : [
      for i, disk in disks : {
        vm_name = vm_name
        disk    = disk
        index   = i + 1
      }
    ]
  ])

  nat_enabled_instances = { for k, v in var.nat_instances : k => v if v == true }
}

resource "cloudstack_disk" "data" {
  for_each = {
    for d in local.disk_map : "data${d.index}-${d.vm_name}" => d
  }

  name               = "DATA${each.value.index}-${each.value.vm_name}"
  disk_offering      = "Custom Disk"
  zone               = var.zone
  size               = each.value.disk.size
  virtual_machine_id = cloudstack_instance.instance[each.value.vm_name].id
  attach             = true
}

resource "cloudstack_ipaddress" "ipaddress" {
  for_each   = local.nat_enabled_instances
  zone       = var.zone
  network_id = var.network_id

  tags = {
    cloud-description = cloudstack_instance.instance[each.key].name
  }
}

resource "cloudstack_static_nat" "static_nat" {
  for_each           = local.nat_enabled_instances
  ip_address_id      = cloudstack_ipaddress.ipaddress[each.key].id
  virtual_machine_id = cloudstack_instance.instance[each.key].id
}

resource "cloudstack_firewall" "firewall" {
  for_each = { for k, v in var.firewall_rules : k => v if contains(keys(local.nat_enabled_instances), k) }

  ip_address_id = cloudstack_ipaddress.ipaddress[each.key].id

  rule {
    cidr_list = each.value.cidr_list
    protocol  = each.value.protocol
    ports     = each.value.ports
  }
}
