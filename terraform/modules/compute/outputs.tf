output "instances" {
  description = "Map of CloudStack instance resources created by this module, keyed by the instance identifiers used in the resource definition."
  value       = cloudstack_instance.instance
}

output "ip_addresses" {
  description = "Map of CloudStack IP address resources created by this module, keyed by the identifiers used in the resource definition."
  value       = cloudstack_ipaddress.ipaddress
}
