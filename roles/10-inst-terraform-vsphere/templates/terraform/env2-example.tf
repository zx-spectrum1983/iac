locals {
  env2 = merge(var.env2-group1, var.env2-group2,)
  }

variable "env2-group1" {
    type = map
    default = {

      #ENV env2-group1
      pod01-vm2-app = {name = "pod01-vm2-app", cpu_count = 1, memory = 1024, datastore = "datastore2", disk_size = 16, template = "tf-templ-ubuntu"},
      pod01-vm2-web = {name = "pod01-vm2-web", cpu_count = 2, memory = 1024, datastore = "datastore2", disk_size = 16, template = "tf-templ-ubuntu"},

    }
  }

variable "env2-group2" {
    type = map
    default = {

      #ENV env2-group2
      pod01-vm2-tapp = {name = "pod01-vm2-tapp", cpu_count = 1, memory = 1024, datastore = "datastore2", disk_size = 16, template = "tf-templ-ubuntu"},
      pod01-vm2-tweb = {name = "pod01-vm2-tweb", cpu_count = 1, memory = 1024, datastore = "datastore2", disk_size = 16, template = "tf-templ-ubuntu"},

    }
  }

