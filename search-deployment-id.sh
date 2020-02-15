# extract artifactId and version from POM file
repoName=`basename ${buildRepository}`  # use basename to remove Org,User,Project, e.g., 'GithubOrgOrUser/vvp' -> 'vvp'
source `dirname $0`/extract-artifact-meta.sh ${repoName}

deploymentId=`curl -X GET "http://localhost:8080/api/v1/namespaces/${vvpNamespace}/deployments" \
    -H "Authorization: Bearer ${vvpAPIToken}" \
    -H "accept: application/json" -s \
    | python -c "
import sys, json
j=json.loads(sys.stdin.read())
for i in j[\"items\"]:
  if i[\"metadata\"][\"name\"] == \"${artifactId}-deployment\":
    print i[\"metadata\"][\"id\"]
"`
echo "##vso[task.setvariable variable=deploymentId]$deploymentId"