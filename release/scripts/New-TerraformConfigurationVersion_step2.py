import requests
import json
import sys
import os

def configversion(workspaceid, token):
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
                "auto-queue-runs": false
                },
            "type": "configuration-version"
            }
        }'''
    serilaized = json.loads(payload)
    #Creating Header content for POST request       
    headers_content ='{"Authorization" : "Bearer  ' + token + '", "Content-Type" : "application/vnd.api+json"}'
    headers = json.loads(headers_content)
    
    url = "https://app.terraform.io/api/v2/workspaces/" + workspaceid + "/configuration-versions"

    try:
        # Creating a file to append the ConfigurationVersion information
        f= open("TFE_CONFIGID.txt","a+")
        # Initialize POST request
        result = requests.post(url, json = serilaized, headers = headers, allow_redirects=False)
        loaded_json = (json.loads(result.content))['data']
        #for i in loaded_json:
        print("\033[1;32mConfigID: " + loaded_json['id'])
        f.write("ConfigID: " + loaded_json['id'] +'\n')
        print("upload-url: " + loaded_json['attributes']['upload-url'])
        f.write("upload-url: " + loaded_json['attributes']['upload-url'] +'\n')
        print('\033[0m')
    except Exception as e:
        print("\033[1;31mError: " + str(e) + "\033[0m")
    finally:
        f.close()
        print("Script Execution Completed")
        print("\n##########################################################################################\n")

def main():
    workspaceid = sys.argv[1]
    token = sys.argv[2]
    configversion(workspaceid, token)
main()