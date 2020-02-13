
# az login
az login --service-principal -u ${servicePrincipal} -p ${servicePrincipalKey} --tenant ${tenantId}

# get cluster credential
az aks get-credentials --resource-group ${resourceGroup} --name ${kubernetesCluster}

# port forward
kubectl port-forward service/vvp-ververica-platform 8080:80 --namespace ${kubernetesNamespace} &
