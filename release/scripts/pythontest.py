import os
import subprocess
myenv = os.getenv('aws_access_key', default="Sample")
print(myenv)
#print(str(os.environ['aws']))
a = subprocess.Popen("env | grep 'bamboo_aws_*'", shell=True, stdout=subprocess.PIPE).stdout
b = a.read()
b = b.decode("utf-8")
b = b.split("\n")
c =[]
for i in b:
    c.append(i.split("="))
for i in c:
    env_vars[i[0]] = i[1]

print(env_vars)