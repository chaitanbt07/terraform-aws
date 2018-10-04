import os
myenv = os.getenv('Path', default="Sample")
print(myenv)
print(os.environ['aws_*'])