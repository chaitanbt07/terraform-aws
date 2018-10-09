import os, re
import subprocess
import sys, json
import requests
a = subprocess.Popen("env | grep 'bamboo_" + sys.argv[1] + "_*'", shell=True, stdout=subprocess.PIPE).stdout
b = a.read()
b = b.decode("utf-8")
b = b.split("\n")
b.pop()
c =[]
env_vars = {}
for i in b:
    c.append(i.split("="))
print("Print C" + str(c))
for i in c:
    env_vars[i[0].replace('bamboo_', '')] = i[1]
    for key in env_vars:
      if 'secret' in key:
        print("key: " + key)
        payload = '''{
            "data": {
               "attributes": {
                    "key": "''' + key + '''",
                    "value": "''' + i[1] + '''",
                    "category": "terraform",
                    "hcl": false,
                    "sensitive": true
                    },
                "relationships": {
                    "workspace": {
                        "data": {
                            "id": "''' + sys.argv[2] + '''",
                            "type": "workspaces"
                            }
                        }
            },
            "type": "vars"
          }
        }'''
        serilaized = json.loads(payload)
        headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json", "charset" : "utf-8" }'
        headers = json.loads(headers_content)
        url = "https://app.terraform.io/api/v2/vars"
        print('result = requests.post(url, json = ' + str(json.dumps(serilaized)) + ', headers = ' + str(json.dumps(headers)) + ', allow_redirects=False)')
      else:
#        print("For key: " + key)
        payload = '''
        {
        "data": {
            "attributes": {
                "key": "''' + key + '''",
                "value": "''' + i[1] + '''",
                "category": "terraform",
                "hcl": true,
                "sensitive": false
                },
                "relationships": {
                    "workspace": {
                        "data": {
                            "id": "''' + sys.argv[2] + '''",
                            "type": "workspaces"
                        }
                }
            },
            "type": "vars"
           }
        }'''
        print("else payload: ")
        serilaized = json.loads(payload)
        print(json.dumps(serilaized))
    #Creating Header content for POST request
        headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json"}'
        headers = json.loads(headers_content)
    #    print("headers")
     #   print(json.dumps(headers))
        url = "https://app.terraform.io/api/v2/vars"
        #print('result = requests.post(url, json = ', serilaized ', headers = ', headers ', allow_redirects=False)')

print(json.dumps(env_vars))