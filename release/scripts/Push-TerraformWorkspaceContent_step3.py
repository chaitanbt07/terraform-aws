import requests
import json
import sys
import os

def workspacecontent(Uri, Path):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    try:
        result = requests.put(Uri, files={'file': Path})
        if result.status_code in range(200, 202):
            print("\033[1;32mContent Successfully uploaded to Workspace...\033[0m")
    except Exception as e:
        print("\033[1;31mError: " + str(e) + "\033[0m")
    finally:
        print("Script Execution Completed")
        print("\n##########################################################################################\n")


def main():
    Uri = sys.argv[1]
    Path = sys.argv[2]
    workspacecontent(Uri, Path)
main()