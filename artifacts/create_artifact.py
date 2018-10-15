import glob, tarfile
tar = tarfile.open("../terraform.tar.gz", "w:gz")
for file in glob.glob("**/*.tf", recursive=True):
    try:
        print("Creating Artifacts....")
        tar.add(file)
    except Exception as e:
        print("Error :" + str(e))
tar.close()
t = tarfile.open("../terraform.tar.gz", "r")
for member in t.getmembers():
    print(member.name)
