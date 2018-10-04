import requests
import json
import sys
import os
import subprocess

def workspacevariable(WorkSpaceID, Provider, Token):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    a = subprocess.Popen("env | grep 'bamboo_'" + Provider + "'_*'", shell=True, stdout=subprocess.PIPE).stdout


def main():
    workspaceid = sys.argv[1]
    provider = sys.argv[2]
    token = sys.argv[3]
    workspacevariable(workspaceid, provider, token)
main()