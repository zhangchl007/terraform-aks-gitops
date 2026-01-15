output "vm_ids" {
  description = "Map of VM IDs"
  value = {
    for k, vm in azurerm_linux_virtual_machine.vm : k => vm.id
  }
}
output "vm_network_security_groups" {
  description = "Map of VM NSG details"
  value = {
    for k, nsg in azurerm_network_security_group.vm : k => {
      nsg_id   = nsg.id
      nsg_name = nsg.name
    }
  }
}

output "jumpserver_details" {
  description = "Jumpserver VM connection details"
  value = try({
    vm_id       = azurerm_linux_virtual_machine.vm["jumpserver"].id
    vm_name     = "${var.env_prefix}-jumpserver"
    private_ip  = azurerm_network_interface.vm["jumpserver"].private_ip_address
    public_ip   = azurerm_public_ip.vm["jumpserver"].ip_address
    ssh_command = "ssh -i ~/.ssh/id_rsa azureuser@${azurerm_public_ip.vm["jumpserver"].ip_address}"
  }, null)
}

output "rocketmq_details" {
  description = "RocketMQ VM connection and service details"
  value = try({
    vm_id               = azurerm_linux_virtual_machine.vm["rocketmq"].id
    vm_name             = "${var.env_prefix}-rocketmq"
    private_ip          = azurerm_network_interface.vm["rocketmq"].private_ip_address
    public_ip           = azurerm_public_ip.vm["rocketmq"].ip_address
    ssh_command         = "ssh -i ~/.ssh/id_rsa azureuser@${azurerm_public_ip.vm["rocketmq"].ip_address}"
    nameserver_endpoint = "${azurerm_network_interface.vm["rocketmq"].private_ip_address}:9876"
    broker_endpoint     = "${azurerm_network_interface.vm["rocketmq"].private_ip_address}:10911"
    broker_ha_endpoint  = "${azurerm_network_interface.vm["rocketmq"].private_ip_address}:10912"
    console_url         = "http://${azurerm_public_ip.vm["rocketmq"].ip_address}:8080"
  }, null)
}

output "all_vm_ssh_commands" {
  description = "SSH commands for all Linux VMs"
  value = {
    for k, config in var.vms : k =>
    config.enable_public_ip && lower(config.os_type) == "linux" ?
    "ssh -i ~/.ssh/id_rsa ${config.admin_username}@${azurerm_public_ip.vm[k].ip_address}" :
    "N/A (no public IP or Windows VM)"
  }
}