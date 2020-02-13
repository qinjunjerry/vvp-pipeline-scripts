# extract artifactId and version from pom.xml
source `dirname $0`/extract-artifact-meta.sh

# extract commit hash
# We use the commit hash in jar URI when POST/PATCH a deployment in VVP, e.g.,
#     wasbs://...../job.jar?commit=e81c66d
# This way VVP will suspend & start the flink job upon a PATCH action
commitHash=`echo ${buildVersion} | cut -c 1-7`

curl -X PATCH "http://localhost:8080/api/v1/namespaces/${vvpNamespace}/deployments/${deploymentId}" \
    -H "Authorization: Bearer ${vvpAPIToken}" \
    -H "accept: application/yaml" -H "Content-Type: application/yaml" -s -d "
kind: Deployment
apiVersion: v1
spec:
  state: RUNNING
  template:
    spec:
      artifact:
        jarUri: >-
          wasbs://${blobContainer}@${storageAccount}.blob.core.windows.net/artifacts/namespaces/${vvpNamespace}/${jarFileName}?commit=${commitHash}
"