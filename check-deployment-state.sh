# extract artifactId and version from POM file
repoName=`basename ${BUILD_REPOSITORY_NAME}`  # use basename to remove Org,User,Project, e.g., 'GithubOrgOrUser/vvp' -> 'vvp'
# this sets artifactId, version
source `dirname $0`/extract-artifact-meta.sh ${repoName}

state=`curl -X GET "http://localhost:8080/api/v1/namespaces/${VVPNAMESPACE}/deployments" \
	-H "Authorization: Bearer ${VVP_APITOKEN}" \
	-H "accept: application/json" -s | \
	jq -r --arg deploymentName "${artifactId}-deployment" '.items[] | select (.metadata.name == $deploymentName) | .status.state ' `

if [ "$state" != "RUNNING" ]; then
    echo Job is still in state: \"$state\"
    exit 1
fi