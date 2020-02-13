# extract artifactId and version from POM file
source `dirname $0`/extract-artifact-meta.sh ${repoName}

# extract commit hash
# We use the commit hash in jar URI when POST/PATCH a deployment in VVP, e.g.,
#     wasbs://...../job.jar?commit=e81c66d
# This way VVP will suspend & start the flink job upon a PATCH action
commitHash=`echo ${buildVersion} | cut -c 1-7`

curl -X POST "http://localhost:8080/api/v1/namespaces/${vvpNamespace}/deployments" \
    -H "Authorization: Bearer ${vvpAPIToken}" \
    -H "accept: application/yaml" -H "Content-Type: application/yaml" -s -d "
kind: Deployment
apiVersion: v1
metadata:
  name: ${artifactId}-deployment
  namespace: ${vvpNamespace}
spec:
  state: RUNNING
  upgradeStrategy:
    kind: STATELESS
  restoreStrategy:
    kind: LATEST_SAVEPOINT
    allowNonRestoredState: false
  deploymentTargetId: ${vvpDeploymentTarget}
  template:
    metadata:
      annotations: {}
    spec:
      artifact:
        kind: JAR
        jarUri: >-
          wasbs://${blobContainer}@${storageAccount}.blob.core.windows.net/artifacts/namespaces/${vvpNamespace}/${jarFileName}?commit=${commitHash}
        flinkVersion: 1.9
        flinkImageRegistry: registry.platform.data-artisans.net/v2.0
        flinkImageRepository: flink
        flinkImageTag: 1.9.2-stream1-scala_2.12
      parallelism: 1
      resources:
        jobmanager:
          cpu: 0.5
          memory: 1G
        taskmanager:
          cpu: 1
          memory: 1G
      flinkConfiguration: {}
      logging:
        log4jLoggers: {}
status:
  state: CANCELLED
"