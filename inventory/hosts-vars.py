#!/usr/bin/python3

import os
import json
import requests

def get_config():
   global isExistT
   if isExistT and isOnline:
      ft = open(tokenfile)
      token = ft.read()
      url = 'http://127.0.0.1:8200/v1/ansible/config'
      headers = {'X-Vault-Token': token}
      response = requests.get(url, headers=headers)
      vaultJson = json.loads(response.text)
      ft.close()
      try:
         for key in vaultJson['data']:
            data['local']['vars'][key] = vaultJson['data'][key]
      except KeyError:
         isExistT = False
         get_config()
      else:
         for key in vaultJson['data']:
            data['local']['vars'][key] = vaultJson['data'][key]
         print(json.dumps(data, indent=4))
         return
   else:
      print(json.dumps(data, indent=4))
   return


varsJson = '{"local":{"vars":{}}}'
data = json.loads(varsJson)

tokenfile = "/home/ansible/.vault_ansible_token"
configfile = "/home/ansible/init-iac.json"
isExistT = os.path.exists(tokenfile)
isExistC = os.path.exists(configfile)

if isExistC:
   ft = open(configfile)
   configJson = json.load(ft)
   data['local']['vars'] = configJson
   ft.close()

try:
   isOnline = requests.head('http://127.0.0.1:8200/v1/sys/health', verify=False, timeout=1)
except:
   isOnline = False
   pass
get_config()

