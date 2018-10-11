import requests
import json
import sys
import os


def workspace(Organization, WorkSpaceName, Token):
    if os.name == 'nt': 
        os.system("cls") 
    else: 
        os.system("clear")
    print("\n##########################################################################################\n")
    print("Script Execution Started")
    #Creating Payload for POST request
    payload = '''{
        "data": {
            "attributes": {
                "name": "''' + WorkSpaceName + '''",
                "auto-apply": true
                },
            "type": "workspaces"
            }
        }'''
    
    serilaized = json.loads(payload)
    # Creating Header content for POST request
    headers_content ='{"Authorization" : "Bearer ' + Token + '", "Content-Type" : "application/vnd.api+json"}'
    headers = json.loads(headers_content)
    
    url = "https://app.terraform.io/api/v2/organizations/" + Organization + "/workspaces"
    
    try:
        # Creating a file to append the Workspace information
        f= open("workspace.txt","a+")
        # Initialize POST request
        result = requests.post(url, json = serilaized, headers = headers, allow_redirects=False)
        if result.status_code == 422 and result.status_code != 200:
            try:
                print("\033[93mWorkspace with name " + WorkSpaceName + " already Exists....\033[0m")
                print("\033[1;32mGetting Workspace Information...\033[1;32m")
                get_result = requests.get(url, headers = headers, allow_redirects=False)
                loaded_json = (json.loads(get_result.content))['data']
                for i in loaded_json:
                        if ((i['attributes']['name']) == WorkSpaceName):
                            print("WorkspaceID: " + i['id'])
                            f.write("WorkspaceID: " + i['id'] +'\n')
                            print("WorkspaceName: " + i['attributes']['name'])
                            f.write("WorkspaceName: " + i['attributes']['name'] +'\n')
                            print('\033[0m')
            except Exception as e:
                print("\033[1;31mcode failed :" + str(e) + "\033[0m")
        elif result.status_code == 404:
            print("\033[1;31mError creating workspace; Check the permission and the organization name and settings\033[0m")
        elif result.status_code == 200 or result.status_code == 201:
            print("\033[1;32mNew Workspace created...")
            print("WorkspaceID: " + (json.loads(result.content))['data']['id'])
            f.write("WorkspaceID: " + (json.loads(result.content))['data']['id'] + "\n")
            print("WorkspaceName: " + WorkSpaceName)
            f.write("WorkspaceName: " + WorkSpaceName + "\n")
            print('\033[0m')
    except Exception as e:
        print("\033[1;31mError: Check Proxy Settings or " + str(e) + "\033[0m")
    finally:
        f.close()
        print("Script Execution Completed")
        print("\n##########################################################################################\n")
        
def main():
    org_name = sys.argv[1]
    workspace_name = sys.argv[2]
    token = sys.argv[3]
    workspace(org_name, workspace_name, token)
main()
