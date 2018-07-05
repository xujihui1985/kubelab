### Setup kubernetes cluster

#### followed by tutorial https://github.com/kelseyhightower/kubernetes-the-hard-way

#### Prerequisites

- Sign up for gcloud https://cloud.google.com/ you will get $300 credits
- download gcloud sdk from https://cloud.google.com/sdk/gcloud/
- setup gcloud choose a zone that close to you geographically
- install golang (for cfssl) from https://golang.org/dl/ and setup go bin to your path
- install cfssl `go get -u github.com/cloudflare/cfssl/cmd/...`

#### run script

- provision instance and network

```
cd provision

./networking.sh

./nodes.sh
```

- generate cert

```
cd cert

./generate.sh
```

- generate kubeconfig

```
cd kubeconfig

./generate-kubeconfig.sh
```

- distribute to instance

```
cd provision

./distribute.sh
```

- provision etcd

```
cd etcd

./bootstrap-etcd.sh
```

- provision controller components

```
cd controller

./bootstrap-controller.sh

```

- provision loadbalancer for api server

```
cd api-loadbalancer

./bootstrap-apilb.sh
```

- provision worker components

```
cd worker

./bootstrap-worker.sh
```

- setup network

```
cd network

./setup.sh
```

- setup client

```
cd client

./setup.sh
```

- provision dns addon

```
cd addon

./setup-dnsaddon.sh
```

### validate

```
cd client

# create a deployment for nginx
kubectl --kubeconfig kubelab.kubeconfig run nginx --image=nginx

# get pod name
POD_NAME=$(kubectl --kubeconfig kubelab.kubeconfig get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")

# port forward
kubectl --kubeconfig kubelab.kubeconfig port-forward $POD_NAME 8080:80

open http://127.0.0.1:8080

```


### cleanup

after finish the lab, cleanup the resource

```
cd cleanup

./cleanup-instances.sh
./cleanup-network.sh
```
