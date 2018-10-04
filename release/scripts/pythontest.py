import os
myenv = os.getenv('aws_access_key', default="Sample")
print(myenv)
#print(str(os.environ['aws']))
a = subprocess.Popen("env | grep 'AWS*'", shell=True, stdout=subprocess.PIPE).stdout
b = a.read()
b.decode("utf-8")
