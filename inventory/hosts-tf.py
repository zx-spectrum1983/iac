#! /usr/bin/python3

import os
import subprocess
import json

tfdir = "/home/ansible/project/terraform"
isExist = os.path.exists(tfdir)

if isExist:
   cwd = os.getcwd()
   os.chdir(tfdir)
   proc = subprocess.run(["terraform", "output", "-json"], stdout=subprocess.PIPE)
   if proc.stdout.decode('utf-8').strip(" \r\n") == "{}":
      print("{ }")
   else:
      proc = subprocess.run(["terraform", "output", "-json", "hosts"], stdout=subprocess.PIPE)
      jsonHosts = json.loads(proc.stdout.decode('utf-8'))
      print(json.dumps(jsonHosts,  indent=4))
   os.chdir(cwd)
else:
   print("{ }")
