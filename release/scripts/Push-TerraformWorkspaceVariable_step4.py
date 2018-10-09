import os
import subprocess
import sys, json
import requests

def workspacevariable(WorkSpaceID="", Provider="", Token=""):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    try:
        a = subprocess.Popen("env | grep 'bamboo_" + sys.argv[1] + "_*'", shell=True, stdout=subprocess.PIPE).stdout
        b = a.read()
        b = b.decode("utf-8")
        b = b.split("\n")
        b.pop()
        c =[]
        env_vars = {}
        for i in b:
            c.append(i.split("="))
        for i in c:
            env_vars[i[0].replace('bamboo_', '')] = i[1]
        for key in env_vars:
            if 'secret' in key:
                print("\033[1;32mkey: " + key)
                payload = dict(data = dict(attributes = dict(key = key, value = env_vars[key], category =  "terraform", hcl = False, sensitive = True), relationships = dict(workspace = dict(data = dict(id = sys.argv[2], type = "workspaces")))), type = "vars")
                serilaized = json.dumps(payload)
    #Creating Header content for POST request
                headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json", "charset" : "utf-8" }'
                headers = json.loads(headers_content)
                url = "https://app.terraform.io/api/v2/vars"
                result = requests.post(url, json = serilaized, headers = headers, allow_redirects=False)
                if result.status_code in range(200, 202):
                    print("\033[1;32mVariable" + env_vars[key] + "Successfully uploaded to Workspace...\033[0m")
                print('\033[0m')
            else:
                print("key: " + key)
                payload = dict(data = dict(attributes = dict(key = key, value = env_vars[key], category =  "terraform", hcl = True, sensitive = False), relationships = dict(workspace = dict(data = dict(id = sys.argv[2], type = "workspaces")))), type = "vars")
                serilaized = json.dumps(payload)
    #Creating Header content for POST request
                headers_content ='{"Authorization" : "Bearer  ' + sys.argv[3] + '", "Content-Type" : "application/vnd.api+json", "charset" : "utf-8"}'
                headers = json.loads(headers_content)
                url = "https://app.terraform.io/api/v2/vars"
                result = requests.post(url, json = serilaized, headers = headers, allow_redirects=False)
                if result.status_code in range(200, 202):
                    print("\033[1;32mVariable" + env_vars[key] + "Successfully uploaded to Workspace...\033[0m")
                print('\033[0m')       
    except Exception as e:
        print("\033[1;31mError : " + str(e) + "\033[0m")
    finally:
        print("Script Execution Completed")
        print("\n##########################################################################################\n")

def main():
    workspaceid = sys.argv[1]
    provider = sys.argv[2]
    token = sys.argv[3]
    workspacevariable(workspaceid, provider, token)
main()
