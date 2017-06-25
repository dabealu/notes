publish container port on host  
(it's possible to change NodePort range with api-server key --service-node-port-range=1-65535 and use NodePort Service)
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: ingress
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: ingress
    spec:
      containers:
        - name: nginx
          image: nginx:1.12
          ports:
            - name: http
              protocol: TCP
              containerPort: 80
              hostPort: 80
```

or use externalIPs service
```
kind: Service
apiVersion: v1
metadata:
  name: ingress
spec:
  selector:
    app: ingress
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  externalIPs:
    - 192.168.99.100  #<- node external ip
```

apply node labels via manifest - current labels will be REPLACED !
```
apiVersion: v1
kind: Node
metadata:
  labels:
    my.label: my.label-value
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/hostname: minikube
  name: minikube
  
```

pvc with mount options in annotation
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs-001
annotations:
  volume.beta.kubernetes.io/mountOptions: "hard,nolock,nfsvers=3"
spec:
  ...
```
