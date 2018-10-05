import requests
import json
import sys
import os
import subprocess

def workspacevariable(WorkSpaceID="", Provider="", Token=""):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    try:
        a = subprocess.Popen("env | grep 'bamboo_" + Provider + "_*'", shell=True, stdout=subprocess.PIPE).stdout
        b = a.read()
        b = b.decode("utf-8")
        b = b.split("\n")
        b.pop()
        c =[]
        env_vars ={}
        for i in b:
            c.append(i.split("="))
        for i in c:
            
            env_vars[i[0]] = i[1]
        print(env_vars)
    except Exception as e:
        print("\033[1;31mError : " + str(e) + "\033[0m")
    #a = subprocess.Popen("env | grep 'bamboo_" + Provider + "_*'", shell=True, stdout=subprocess.PIPE).stdout
<<<<<<< Updated upstream
    a = subprocess.Popen("env | grep 'bamboo_" + Provider + "_*'", shell=True, stdout=subprocess.PIPE).stdout
    b = a.read()
    b = b.decode("utf-8")
    b = b.split("\n")
    b.pop()
    c =[]
    env_vars ={}
    for i in b:
        c.append(i.split("="))
    for i in c:
        print(env_vars[i[0]] = i[1])
    #print(env_vars[0])

    #print(env_vars)
=======
    finally:
        print("Script Execution Completed")
        print("\n##########################################################################################\n")
>>>>>>> Stashed changes

def main():
    workspaceid = sys.argv[1]
    provider = sys.argv[2]
    token = sys.argv[3]
    workspacevariable(workspaceid, provider, token)
main()
