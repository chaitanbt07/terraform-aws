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
        print(buildkey.read())
        print(buildnum.read())
        comment = "Run Requested by Release for " + buildkey.read() + " build number " + buildnum.read()
        print(comment)
    except Exception as e:
        print("Error: " + str(e) + "\n")

def main():
    workspacerun()
main()