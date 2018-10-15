import glob, tarfile
tar = tarfile.open("../terraform.tar.gz", "w:gz")
for file in glob.glob("**/*.tf", recursive=True):
    tar.addfile(file)
tar.close()
