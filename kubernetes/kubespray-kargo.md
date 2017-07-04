##### setup k8s via kubespray (kargo)
some useful cluster setup vars
```
### inventory/group_vars/all.yml
# use local nginx on workers to balance across api servers
loadbalancer_apiserver_localhost: true

# allow kubelet to load kernel modules, i.e. for ceph rdb
kubelet_load_modules: true

### inventory/group_vars/k8s-cluster.yml
# api server password
kube_api_pwd: "something-secure"

# use flannel instead of calico
kube_network_plugin: flannel

# pods/services subnets
kube_service_addresses: 10.0.0.0/18
kube_pods_subnet: 10.0.64.0/18
kube_network_node_prefix: 22

# kubelet custom options roles/kubernetes/node/defaults/main.yml
kubelet_custom_flags:
  - "--max-pods=512"
  
# other components can have custom flags too
# https://github.com/kubernetes-incubator/kubespray/blob/master/docs/vars.md
```

start setup
```
apt-get update && apt-get install -y git python-dev python-pip libffi-dev libssl-dev libxml2-dev libxslt1-dev
pip install ansible netaddr
git clone https://github.com/kubernetes-incubator/kargo.git
cd kargo
cat <<EOF > inventory/hosts
node1 ansible_connection=local
[kube-master]
node1
[etcd]
node1
[kube-node]
node1
[k8s-cluster:children]
kube-node
kube-master
EOF
ansible-playbook -i inventory/hosts cluster.yml -u root -v
```


##### adding master/etcd node to cluster
example initial hosts:
```
node1 ansible_host=192.168.100.201
 
[kube-master]
node1

[etcd]
node1

[kube-node]
node1
```

then we add one more master node2:
```
node1 ansible_host=192.168.100.201
node2 ansible_host=192.168.100.202
 
[kube-master]
node1
node2

[etcd]
node1
node2

[kube-node]
node1
node2
```

run playbook, notice limiting to node2 only.
it will fail at `etcd : Backup etcd v2 data` step - its ok.
```
ansible-playbook -v -i hosts -l node2 cluster.yml
```

at node2:
```
rm -rf /var/lib/etcd/*
systemctl restart etcd
```

check cluster health:
```
docker exec -ti etcd2 etcdctl \
  --cert-file /etc/ssl/etcd/ssl/member-node2.pem \
  --key-file /etc/ssl/etcd/ssl/member-node2-key.pem --ca-file /etc/ssl/etcd/ssl/ca.pem \
  --endpoints https://127.0.0.1:2379 cluster-health
```

run playbook again, to finish node2 setup:
```
ansible-playbook -v -i hosts cluster.yml
```

check that node2 successfully added to cluster:
```
kubectl get node
```


##### deleting one of masters node
i.e. we want to delete `node1`:
```
# make node unschedulable
kubectl delete node node1

# get etcd node id which we want to remove
# we can do it from another node in case of node1 is down
docker exec -ti etcd1 etcdctl \
  --cert-file /etc/ssl/etcd/ssl/member-node1.pem \
  --key-file /etc/ssl/etcd/ssl/member-node1-key.pem --ca-file /etc/ssl/etcd/ssl/ca.pem \
  --endpoints https://127.0.0.1:2379 member list
  
# WARNING: preserve etcd quorum !
# i.e. if one of two nodes removed
# you end up with broken cluster

# remove etcd node
docker exec -ti etcd1 etcdctl \
  --cert-file /etc/ssl/etcd/ssl/member-node1.pem \
  --key-file /etc/ssl/etcd/ssl/member-node1-key.pem --ca-file /etc/ssl/etcd/ssl/ca.pem \
  --endpoints https://127.0.0.1:2379 member remove 1f1045449f5a28cb

# remove node1 from inventory file

# after running cluster playbook (this step isn't required)
# etcd nodes will be renamed
ansible-playbook -v -i hosts cluster.yml
```


##### renew cert's SANs on master
this can be useful after one of master nodes get replaced or added to update SANs in apiserver cert  
because some components (kube-proxy) on workers can check SANs and fail to start  
```
cd /etc/kubernetes

# get current API cert info
openssl x509 -in ssl/apiserver.pem -text -noout

# backup current certs
mv ssl ssl_bak

# rerun cluster playbook to generate new certs
ansible-playbook -i hosts -l kube-master cluster.yml

# restart kubelet on worker
systemctl restart kubelet
```
