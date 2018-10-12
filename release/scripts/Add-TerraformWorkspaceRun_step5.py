import requests
import os
import sys
import subprocess
import json
import re


def workspacerun(WorkSpaceID, ConfigVersionID, Token):
    if os.name == 'nt':
        os.system("cls")
    else:
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started\n")
    buildkey = subprocess.Popen("env | grep 'bamboo_buildKey'", shell=True, stdout=subprocess.PIPE).stdout
    buildnum = subprocess.Popen("env | grep 'bamboo_buildResultKey'", shell=True, stdout=subprocess.PIPE).stdout
    buildkey = ((buildkey.read()).decode("utf-8")).split("=")
    buildnum = ((buildnum.read()).decode("utf-8")).split("=")
    comment = "Run Requested by Release for " + buildkey[1].replace("\n", "") + " build number " + buildnum[1].replace("\n", "")
    print(comment)
    payload = dict(data=dict(type='runs', attributes=dict((('is-destroy', 'false'), ('message', comment))),
                             relationships=dict([((
                             'configuration-version', dict(data=dict(type='configuration-versions', id=ConfigVersionID))))],
                                                workspace=dict(data=dict(type='workspaces', id=WorkSpaceID)))))
    serialized = json.dumps(payload)
    print(serialized)
    # Creating Header content for POST request
    headers_content = '{"Authorization" : "Bearer ' + Token + '", "Content-Type" : "application/vnd.api+json"}'
    headers = json.loads(headers_content)
    url = "https://app.terraform.io/api/v2/runs"
    #try:
    # Creating a file to append the RUN information
    #f = open("TFE_RUNID.txt", "a+")
    # Initialize POST request
    result = requests.post(url, json=payload1, headers=headers, allow_redirects=False)
    print("result = requests.post(" + url + ", json=" + str(payload1) + ", headers=" + str(headers) + ", allow_redirects=False")
    print(result.content)
    #loaded_json = (json.loads(result.content))['data']
    #print(loaded_json)
    #if result.status_code in range(200, 203):
     #   print("New Run created for workspace with WorkspaceID " + WorkSpaceID + "\n")
        #print("RunID: " + loaded_json['attributes']['id'])
        #f.write("RunID: " + loaded_json['attributes']['id'])
    #except Exception as e:
    #   print("Error: " + str(e) + "\n")
    #finally:
    #f.close()


def main():
    workspaceid = sys.argv[1]
    configid = sys.argv[2]
    token = sys.argv[3]
    workspacerun(workspaceid, configid, token)


main()
