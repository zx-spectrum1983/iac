output "hosts" {
  value = {
    terraform_group = {
      hosts = [for vm in vsphere_virtual_machine.vm : vm.name]
      },
    _meta = {
      hostvars = tomap ({
        for vm in vsphere_virtual_machine.vm : vm.name => tomap ({
          "ansible_host" = vm.guest_ip_addresses[0]
          })
        })
      }
    }
}
