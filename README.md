# Infrastructure as code

A script for automatic installation and configuration of a system that allows you to manage your IT infrastructure using the principles - infrastructure as code. This script will be useful for small projects where all environment hosts are located on the same network, as well as for novice DevOps engineers to learn the principles of infrastructure automation. As a result of the script, the following components will be installed and configured automatically:
- Docker-compose - a tool for deploying applications in docker containers.
- Vault - storage of secrets.
- Packer - a tool for creating OS images.
- Terraform - a tool for managing external resources.
- Gitlab - a tool for storing and managing repositories.

## Test stand:

- vSphere 6.7
- External DNS/DHCP server
- Debian 11 virtual machine for system installation (2 cores, 6GB RAM)

>Attention!
>This system does not affect existing hosts on the hypervisor. Modification and deletion is possible only for those hosts that were created through this system. If you try to create a host with an existing name, you will get an error.

## Description of infrastructure:

All infrastructure hosts are located on the hypervisor on the same network and receive network settings automatically via a DHCP server. To create a new host, just add its name to inventory and do a git push to the gitlab server. The infrastructure change pipeline will only run if there are changes to the inventory. After the host is created, the resulting ip will be dynamically substituted into inventory, which can be checked with the ansible-inventory --list command. If necessary, in inventory, you can specify the parameters of the created host, such as: CPUs, RAM, datastore. A new environment is created in the inventory/environments directory, as shown in the examples. The environment file specifies the groups that will be associated with this environment. Each environment has its own default host settings. The created hosts have a basic operating system setup, SSH keys are installed on them, and you can apply your own ansible scripts to them.

During the installation of the system, the configuration and secrets are transferred to Vault and are subsequently taken from there. Two templates for virtual machines will be created automatically and ready for use, if you do not need them, you can disable their creation in the configuration. Upon completion of the installation, your infrastructure repository will be located on the local Gitlab server and ready to go.

## Preparation for installation:

The system requires at least one ESXi hypervisor and a virtual machine with vCenter. The network where the hosts will be created must have a DNS/DHCP server configured.

Download the installation images for creating templates debian-11.5.0-amd64-netinst.iso and ubuntu-14.04.1-server-amd64.iso and save to a folder on your hypervisor.

Create a virtual machine with Debian 11 settings, 2 cores, 6GB RAM to install the system on it. On this host, you need to install sudo, git and ansible.

```
# apt install sudo git ansible
```

The script is supposed to be run as the ansible user, to do this, add it to the sudo group and disable the password for privilege escalation:

```
# usermod -aG sudo
# visudo
Append at the end of the file:
%sudo ALL=(ALL) NOPASSWD: ALL
```

Relogin to the console to apply the settings.

## Installation:

In the ansible user's home directory, create two installation configuration files. Don't forget to remove them after installation. In the vSphere configuration, you can specify cluster or host ESXi if cluster is not configured for you.

**init-cloud.json**

```
{
  "Comment": "Terraform & packer connection",

  "tf_vsphere_server": "vcenter.vsphere.local",
  "tf_vsphere_user": "administrator@vsphere.local",
  "tf_vsphere_password": "admin_vsphere_password",
  "tf_datacenter": "dc",
  "tf_cluster": "",
  "tf_host": "192.168.1.100"
}
```

**init-iac.json**

```
{
  "Comment": "IAC settings",

  "project_dir": "/opt/project",
  "inventory_envoriments_dir": "envoriments",

  "Comment": "Packer template settings",

  "tf_packer_debian11": true,
  "tf_packer_ubuntu14": true,
  "tf_packer_init_ssh_username": "ansible",
  "tf_packer_init_ssh_password": "ansible_",
  "tf_packer_dst_datastore": "datastore1",
  "tf_packer_dst_network": "VM Network",
  "tf_packer_ubuntu14_iso_path": "[datastore2] iso/ubuntu-14.04.1-server-amd64.iso",
  "tf_packer_debian11_iso_path": "[datastore2] iso/debian-11.5.0-amd64-netinst.iso",

  "Comment": "Gitlab settings",

  "gitlab_username": "ansible",
  "gitlab_password": "ansible_",
  "gitlab_email": "ansible@vsphere.local",

  "Comment": "Vault settings",

  "vault_engine_init": true,
  "vault_engine_name": "ansible"
}
```

Run the following commands to start the installation:

```
@ git clone https://github.com/zx-spectrum1983/iac.git
@ cd iac
@ ansible-playbook playbooks/init-env.yml
```

If something went wrong during the installation process, find out what is missing and run the script again. Once installed, delete the init-cloud.json and init-iac.json files.

## Contact:

Николай Дусенко [Nickolay Dusenko](https://t.me/zx_spe)
