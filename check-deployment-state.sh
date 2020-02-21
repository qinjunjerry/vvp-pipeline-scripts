# extract artifactId and version from POM file
repoName=`basename ${BUILD_REPOSITORY_NAME}`  # use basename to remove Org,User,Project, e.g., 'GithubOrgOrUser/vvp' -> 'vvp'
source `dirname $0`/extract-artifact-meta.sh ${repoName}

state=`curl -X GET "http://localhost:8080/api/v1/namespaces/default/deployments" \
-H "Authorization: Bearer ${vvpAPIToken}" \
-H "accept: application/json" -s \
| python -c "
import sys, json
j=json.loads(sys.stdin.read())
for i in j[\"items\"]:
      if i[\"metadata\"][\"name\"] == \"${ARTIFACTID}-deployment\":
              print i[\"status\"][\"state\"]
"`

if [ "$state" != "RUNNING" ]; then
    echo Job is still in state: \"$state\"
    exit 1
fi