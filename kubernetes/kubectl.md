```
# get nodes labels
kubectl get nodes --show-labels

# get pods with label 'app' value as a column
kubectl get pods -L app

# get all nodes IPs (https://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns https://kubernetes.io/docs/user-guide/jsonpath/)
kubectl get node -ojsonpath={.items[*].status.addresses[1].address}

```

##### point kubectl to cluster:
```
# prereq: get certs from master node
CA_CERT=ssl/ca.pem 
ADMIN_KEY=ssl/admin-node1-key.pem 
ADMIN_CERT=ssl/admin-node1.pem 
MASTER_HOST=192.168.100.201:6443

kubectl config set-cluster c1-cluster --server=https://${MASTER_HOST} --certificate-authority=${CA_CERT}
kubectl config set-credentials c1-admin --certificate-authority=${CA_CERT} --client-key=${ADMIN_KEY} --client-certificate=${ADMIN_CERT}
kubectl config set-context c1-system --cluster=c1-cluster --user=c1-admin
kubectl config use-context c1-system

```
