import os
import subprocess
myenv = os.getenv('aws_access_key', default="Sample")
print(myenv)
#print(str(os.environ['aws']))
a = subprocess.Popen("env | grep 'bamboo_aws_*'", shell=True, stdout=subprocess.PIPE).stdout
b = a.read()
print(b.decode("utf-8"))
