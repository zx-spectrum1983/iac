#! /usr/bin/python3

import os
import subprocess
import json

cwd = os.getcwd()
os.chdir('/home/ansible/project/terraform')

proc = subprocess.run(["terraform", "output", "-json", "hosts"], stdout=subprocess.PIPE)
jsonHosts = json.loads(proc.stdout.decode('utf-8'))
print(json.dumps(jsonHosts,  indent=4))

os.chdir(cwd)
