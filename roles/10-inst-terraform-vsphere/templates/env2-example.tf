locals {
  env2 = merge(var.env2-group1, var.env2-group2,)
  }

variable "env2-group1" {
    type = map
    default = {

      #ENV env2-group1
      pod01-vm1-app = {name = "pod01-vm1-app", cpu_count = 1, memory = 1024, datastore = "datastore2", disk_size = 16, network="VM Network", template = "tf-templ-debian11", guest_id="debian10_64Guest"}},
      pod01-vm2-web = {name = "pod01-vm2-web", cpu_count = 1, memory = 1024, datastore = "datastore2", disk_size = 16, network="VM Network", template = "tf-templ-debian11", guest_id="debian10_64Guest"}},

    }
  }

variable "env2-group2" {
    type = map
    default = {

      #ENV env2-group2
      pod02-vm1-app = {name = "pod01-vm1-app", cpu_count = 1, memory = 1024, datastore = "datastore3", disk_size = 16, network="VM Network", template = "tf-templ-ubuntu14", guest_id="ubuntu64Guest"},
      pod02-vm2-web = {name = "pod02-vm2-web", cpu_count = 1, memory = 1024, datastore = "datastore3", disk_size = 16, network="VM Network", template = "tf-templ-ubuntu14", guest_id="ubuntu64Guest"},

    }
  }

