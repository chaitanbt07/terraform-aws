import glob, tarfile, sys

def create_artifact(filename, searchstring):
    tar = tarfile.open(filename, "w:gz")
    for file in glob.glob("**/*." + searchstring, recursive=True):
        try:
            tar.add(file)
        except Exception as e:
            print("Error :" + str(e))
    tar.close()
    t = tarfile.open(filename, "r")
    for member in t.getmembers():
        print(member.name + " uploaded to artifactory")

def main():
    filename = sys.argv[1]
    searchstring = sys.argv[2]
    create_artifact(filename, searchstring)
main()