import os, re
import subprocess
import sys, json
import requests
a = subprocess.Popen("env | grep 'bamboo_" + sys.argv[1] + "_*'", shell=True, stdout=subprocess.PIPE).stdout
b = a.read()
#print("print b :")
#print(b)
b = b.decode("utf-8")
b = b.split("\n")
b.pop()
c =[]
env_vars = {}
for i in b:
    c.append(i.split("="))
for i in c:
    env_vars[i[0].replace('bamboo_', '')] = i[1]
print(json.dumps(env_vars))
for key in env_vars:
      if 'secret' in key:
        print("key: " + key)
        payload = dict(data = dict(attributes = dict(key = key, value = env_vars[key], category =  "terraform", hcl = False, sensitive = True), relationships = dict(workspace = dict(data = dict(id = sys.argv[2], type = "workspaces")))), type = "vars")
        serilaized = json.dumps(payload)
        print(serilaized)
    #Creating Header content for POST request
        headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json", "charset" : "utf-8" }'
        headers = json.loads(headers_content)
        url = "https://app.terraform.io/api/v2/vars"
        print('result = requests.post(url, json = ' + json.dumps(serilaized) + ', headers = ' + json.dumps(headers) + ', allow_redirects=False)')
      else:
        print("key: " + key)
        payload = dict(data = dict(attributes = dict(key = key, value = env_vars[key], category =  "terraform", hcl = True, sensitive = False), relationships = dict(workspace = dict(data = dict(id = sys.argv[2], type = "workspaces")))), type = "vars")
        serilaized = json.dumps(payload)
        
    #Creating Header content for POST request
        headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json", "charset" : "utf-8"}'
        headers = json.loads(headers_content)
        url = "https://app.terraform.io/api/v2/vars"
        print('result = requests.post(url, json = ' + json.dumps(serilaized) + ', headers = ' + json.dumps(headers) + ', allow_redirects=False)')

#print(json.dumps(env_vars))