Test stand:
- vSphere 6.7
- External DNS/DHCP server
- Debian 11

<h2> Installation </h2>

```
create new VM with ansible user
# ssh ansible@yourserver.local
# su -
# apt install git ansible -y
# cd /home/ansible
# touch init-iac.yml
# vi init-iac.yml # смотри содержимое файла ниже
# git clone https://github.com/zx-spectrum1983/iac.git
# cd iac
# ansible-playbook playbooks/init-env.yml
```

<h2>Content of /home/ansible/init-iac.json</h2>

```
{
  "Comment": "IAC settings",

  "git_project_dir": "/home/ansible/iac",
  "project_dir": "/home/ansible/project",
  "inventory_envoriments_dir": "/home/ansible/iac/inventory/envoriments",

  "Comment": "Terraform & packer connection",

  "tf_vsphere_server": "vcenter.vcloud.local",
  "tf_vsphere_user": "administrator@vcloud.local",
  "tf_vsphere_password": "vsphere_password",
  "tf_datacenter": "dc",
  "tf_cluster": "",
  "tf_host": "192.168.1.100",

  "Comment": "Packer template settings",

  "tf_packer_debian11": true,
  "tf_packer_ubuntu14": true,
  "tf_packer_init_ssh_username": "ansible",
  "tf_packer_init_ssh_password": "ansible",
  "tf_packer_dst_datastore": "datastore1",
  "tf_packer_dst_network": "VM Network",
  "tf_packer_ubuntu14_iso_path": "[datastore1] iso/ubuntu-14.04.1-server-amd64.iso",
  "tf_packer_debian11_iso_path": "[datastore1] iso/debian-11.5.0-amd64-netinst.iso",

  "Comment": "Gitlab settings",

  "gitlab_username": "ansible",
  "gitlab_password": "ansible_",
  "gitlab_email": "ansible@vcloud.local",

  "Comment": "Vault settings",

  "vault_engine_init": true,
  "vault_engine_name": "ansible"
}
```

