#!/bin/bash

export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN=`cat /etc/vault/.vault_ansible_token`

packer build -force .
