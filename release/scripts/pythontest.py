import os
myenv = os.getenv('aws_access_key', default="Sample")
print(myenv)
print(os.environ['Path'])
