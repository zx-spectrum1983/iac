locals {
  vsphere_server       = "${data.vault_generic_secret.cloud.data["tf_vsphere_server"]}"
  vsphere_user         = "${data.vault_generic_secret.cloud.data["tf_vsphere_user"]}"
  vsphere_password     = "${data.vault_generic_secret.cloud.data["tf_vsphere_password"]}"

  datacenter           = "${data.vault_generic_secret.cloud.data["tf_datacenter"]}"
  cluster              = "${data.vault_generic_secret.cloud.data["tf_host"]}"

  vms = merge( var.empty,)

}

variable "empty" {
    type = map
    default = {}
}
