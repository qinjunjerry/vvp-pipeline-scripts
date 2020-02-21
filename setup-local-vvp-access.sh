
# az login
az login --service-principal -u ${SERVICEPRINCIPAL} -p ${servicePrincipalKey} --tenant ${tenantId}

# get cluster credential
az aks get-credentials --resource-group ${RESOURCEGROUP} --name ${KUBERNETESCLUSTER}

# port forward
kubectl port-forward service/vvp-ververica-platform 8080:80 --namespace ${KUBERNETESNAMESPACE} &
