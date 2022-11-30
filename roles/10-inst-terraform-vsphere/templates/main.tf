provider "vault" {
  address = "http://127.0.0.1:8200"
  token = file("/etc/vault/.vault_ansible_token")
}

data "vault_generic_secret" "config"{
  path = "ansible/config"
}

data "vault_generic_secret" "cloud"{
  path = "ansible/cloud"
}

provider "vsphere" {
  vsphere_server = local.vsphere_server
  user           = local.vsphere_user
  password       = local.vsphere_password
  allow_unverified_ssl = true
}

#################################################################

data "vsphere_datacenter" "dc" {
  name           = local.datacenter
}

data "vsphere_host" "host" {
  name           = local.cluster
  datacenter_id  = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  for_each = local.vms
  name           = each.value.tf_datastore
  datacenter_id  = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each = local.vms
  name           = each.value.tf_network
  datacenter_id  = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  for_each = local.vms
  name           = "/${local.datacenter}/vm/${each.value.tf_template}"
  datacenter_id  = data.vsphere_datacenter.dc.id
}

##################################################################

resource "vsphere_virtual_machine" "vm" {

  for_each = local.vms

  name             = each.value.tf_name
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore[each.value.tf_name]["id"]

  num_cpus = each.value.tf_cpu_count
  memory   = each.value.tf_memory

  network_interface {
    network_id = data.vsphere_network.network[each.value.tf_name]["id"]
  }

  wait_for_guest_net_timeout = -1
  wait_for_guest_ip_timeout  = 1

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = each.value.tf_disk_size
  }

  guest_id = each.value.tf_guest_id

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.value.tf_name]["id"]
  }
  provisioner "file" {
    source = "~/.ssh/id_rsa.pub"
    destination = "/tmp/id_rsa.pub"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${each.value.tf_name}",
      "sudo sed -i 's/${each.value.tf_template}/${each.value.tf_name}/g' /etc/hosts",
      "sudo pkill dhclient && sudo /sbin/dhclient -4",
      "mkdir /home/${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}/.ssh && touch /home/${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}/.ssh/authorized_keys",
      "chmod 700 /home/${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}/.ssh && chmod 600 /home/${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}/.ssh/authorized_keys",
      "cat /tmp/id_rsa.pub >> /home/${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}/.ssh/authorized_keys",
    ]
  }
  connection {
    type = "ssh"
    host = "${self.guest_ip_addresses[0]}"
    user = "${data.vault_generic_secret.config.data["tf_packer_init_ssh_username"]}"
    password = "${data.vault_generic_secret.config.data["tf_packer_init_ssh_password"]}"
    port = "22"
    agent = false
    }
}

