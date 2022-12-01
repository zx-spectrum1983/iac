#!/usr/bin/python3

import os
import json
import requests
import subprocess

def get_ip():
   try:
      data['local']['vars']['project_dir']
   except:
      print(json.dumps(data, indent=4))
      return
   tfdir = data['local']['vars']['project_dir']+"/terraform"
   isExist = os.path.exists(tfdir)
   if isExist:
      cwd = os.getcwd()
      os.chdir(tfdir)
      proc = subprocess.run(["terraform", "output", "-json"], stdout=subprocess.PIPE)
      if proc.stdout.decode('utf-8').strip(" \r\n") == "{}":
         print(json.dumps(data, indent=4))
      else:
         proc = subprocess.run(["terraform", "output", "-json", "hosts"], stdout=subprocess.PIPE)
         jsonHosts = json.loads(proc.stdout.decode('utf-8'))
         data['_meta'] = jsonHosts['_meta']
         data['terraform_group'] = jsonHosts['terraform_group']
         print(json.dumps(data, indent=4))
      os.chdir(cwd)
   else:
      print(json.dumps(data, indent=4))
   return

def get_config():
   global isExistT
   global data
   if isExistT and isExistE and isOnline:
      ft = open(tokenfile)
      token = ft.read()
      url = 'http://127.0.0.1:8200/v1/'+enginename+'/config'
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
         get_ip()
         return
   else:
      get_ip()
   return


varsJson = '{"local":{"vars":{}}}'
data = json.loads(varsJson)

tokenfile = "/etc/vault/.vault_ansible_token"
enginefile = "/etc/vault/.vault_engine"
configfile = os.path.expanduser("~")+"/init-iac.json"
icloudfile = os.path.expanduser("~")+"/init-cloud.json"

isExistT = os.path.exists(tokenfile)
isExistE = os.path.exists(enginefile)
isExistC = os.path.exists(configfile)
isExistI = os.path.exists(icloudfile)

if isExistC:
   ft = open(configfile)
   configJson = json.load(ft)
   data['local']['vars'] = configJson
   ft.close()

if isExistI:
   ft = open(icloudfile)
   cloudJson = json.load(ft)
   for key in cloudJson:
      data['local']['vars'][key] = cloudJson[key]
   ft.close()

if isExistE:
   ft = open(enginefile)
   enginename = ft.read()
   ft.close()

try:
   isOnline = requests.head('http://127.0.0.1:8200/v1/sys/health', verify=False, timeout=1)
except:
   isOnline = False
   pass

get_config()

