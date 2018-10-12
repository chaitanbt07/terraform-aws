import glob, tarfile
tar = tarfile.open("terraform.tar.gz", "w:gz")
for file in glob.glob("**/*.tf", recursive=True):
    tar.add(file)
tar.close()