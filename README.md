<h2> Установка </h2>
 - #create new VM and connect as root
 - apt install git ansible -y
 - cd ~
 - touch init-iac.yml
 - vi init-iac.yml # смотри содержимое файла ниже
 - git clone https://github.com/zx-spectrum1983/iac.git
 - cd iac
 - ansible-playbook playbooks/init-env.yml



<h2>Содержимое файла init-iac.yml</h2>

```
init_ansible_password            : ansible
project_dir                      : "/opt"

# Terraform & packer connection
tf_vsphere_server                : "vcenter.vsphere.local"
tf_vsphere_user                  : "administrator@vsphere.local"
tf_vsphere_password              : "vcenter_password"
tf_datacenter                    : "dc"
tf_cluster                       : ""
tf_host                          : "192.168.1.100"
tf_datastore                     : "datastore1"
tf_network_name                  : "VM Network"

# Packer template settings
# Before run script you must upload ubuntu-14.04.1-server-amd64.iso to datastore/iso
tf_vm_template                   : true
tf_vm_template_name              : "tf-templ-ubuntu"
tf_vm_template_ssh_username      : "ansible"
tf_vm_template_ssh_password      : "ansible"
tf_vm_template_iso_path          : "[datastore1] iso/ubuntu-14.04.1-server-amd64.iso"
tf_vm_template_guest_os_type     : "ubuntu64Guest"
tf_vm_template_CPUs              : 1
tf_vm_template_RAM               : 1024
tf_vm_template_disk_size         : 16384
tf_vm_template_disk_thin         : "true"
tf_vm_template_addition_pkgs     : "git ansible"
tf_vm_template_ssh_key           : "/home/ansible/.ssh/id_rsa.pub"
```

