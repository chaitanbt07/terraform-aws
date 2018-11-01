#!/bin/bash

dateformat=$(date +"%Y%m%d%H%S")
touch artifact.txt
for i in $3 $4
do
upload=$(curl -u$1:$2 -T $i.tar.gz "http://10.10.22.98:8081/artifactory/$i-artifact-repo/$i-$dateformat.tar.gz")
echo ""$i"_Repo: $(echo $upload | jq -r '.repo')" >> artifact.txt
echo ""$i"_Path: $(echo $upload | jq -r '.path' | cut --delimiter="/" -f 2)" >> artifact.txt
echo ""$i"_Download-URI: $(echo $upload | jq -r '.downloadUri')" >> artifact.txt
done