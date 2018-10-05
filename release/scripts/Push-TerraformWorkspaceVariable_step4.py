import requests
import json
import sys
import os
import subprocess

def workspacevariable(WorkSpaceID="daefefae", Provider="aws", Token="122121212rwr34"):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    a = subprocess.Popen("env | grep 'bamboo_" + Provider + "_*'", shell=True, stdout=subprocess.PIPE).stdout
    b = a.read()
    b = b.decode("utf-8")
    b = b.split("\n")
    c =[]
    env_vars ={}
    for i in b:
        c.append(i.split("="))
    for i in c:
        env_vars[i[0]] = i[1]

    print(env_vars)

def main():
    workspaceid = sys.argv[1]
    provider = sys.argv[2]
    token = sys.argv[3]
    workspacevariable(workspaceid, provider, token)
main()