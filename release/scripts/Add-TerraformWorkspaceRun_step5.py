import requests
import os
import sys
import subprocess

#def workspacerun(WorkSpaceID,ConfigVersionID,Token):
def workspacerun():
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
        print(comment)
    except Exception as e:
        print("Error: " + str(e) + "\n")

def main():
    workspacerun()
main()