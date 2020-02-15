# extract artifactId and version from POM file
repoName=`basename ${buildRepository}`  # use basename to remove Org,User,Project, e.g., 'GithubOrgOrUser/vvp' -> 'vvp'
source `dirname $0`/extract-artifact-meta.sh ${repoName}

# extract commit hash
# We use the commit hash in jar URI when POST/PATCH a deployment in VVP, e.g.,
#     wasbs://...../job.jar?commit=e81c66d
# This way VVP will suspend & start the flink job upon a PATCH action
commitHash=`echo ${buildVersion} | cut -c 1-7`

confFile=${repoName}/${vvpDeploymentConfFile}
eval "
curl -X PATCH \"http://localhost:8080/api/v1/namespaces/${vvpNamespace}/deployments/${deploymentId}\" \
    -H \"Authorization: Bearer ${vvpAPIToken}\" \
    -H \"accept: application/yaml\" -H \"Content-Type: application/yaml\" -s -d \"
`cat ${confFile}`
\"
"