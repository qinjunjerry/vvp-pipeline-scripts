# vvp-pipeline-scripts

These are the uitility scripts which help integrate [Microsoft Azure Pipleline](https://azure.microsoft.com/en-us/services/devops/pipelines/) with [Ververica Platform](https://www.ververica.com/platform-overview).

### setup-local-vvp-access.sh
az login, retrieve cluster credentials, then forward the local port 8080 to Ververica Platform service port 80.

### search-deployment-id.sh
Given an artifactId, search for the corresponding deployment ID in Ververica Platform. This sets `deploymentId` to:
- The actual deploymentId, if found
- '' (empty string), otherwise

### create-new-deployment.sh
Create a new deployment.

### update-existing-deployment.sh
Update an existing deployment.

### check-deployment-state.sh
Check the state of a deployment to see whether it is `RUNNING`.

### extract-artifact-meta.sh
This is a script called by some of the scripts above. It extracts `artifactId` and `version` from the given POM file and builds the full jar file name (`jarFileName`).