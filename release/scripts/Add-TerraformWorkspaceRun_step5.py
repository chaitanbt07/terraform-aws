import requests
import os
import sys
import subprocess

def workspacerun(WorkSpaceID,ConfigVersionID):
#def workspacerun():
    if os.name == 'nt':
        os.system("cls")
    else:
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started\n")
    try:
        f = open("TFE_RUNID.txt", "a+")
        buildkey = subprocess.Popen("env | grep 'bamboo_buildKey'", shell=True, stdout=subprocess.PIPE).stdout
        buildnum = subprocess.Popen("env | grep 'bamboo_buildResultKey'", shell=True, stdout=subprocess.PIPE).stdout
        buildkey = ((buildkey.read()).decode("utf-8")).split("=")
        buildnum = ((buildnum.read()).decode("utf-8")).split("=")
        comment = "Run Requested by Release for " + buildkey[1].replace("\n", "") + " build number " + buildnum[1].replace("\n", "")
        print("\033[1;32m")
        #payload = dict(
         #   data=dict(attributes=dict(key=key, value=env_vars[key], category="terraform", hcl=False, sensitive=True),
          #            relationships=dict(workspace=dict(data=dict(id=WorkSpaceID, type="workspaces")))), type="vars")
        payload = dict(data=dict(attributes=dict(is-destroy=False, message=comment)), type="runs", relationships=dict(workspace=dict(data=dict(type="workspaces", id=WorkSpaceID)), configuration-version=dict(data=dict(type="configuration-versions", id=ConfigVersionID))))
    except Exception as e:
        print("Error: " + str(e) + "\n")

def main():
    workspaceid = sys.argv[1]
    configid = sys.argv[2]
    workspacerun()
main()