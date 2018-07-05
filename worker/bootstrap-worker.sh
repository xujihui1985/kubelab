#!/bin/bash

kubelab::provision::worker::setupworker() {
  local instance=$1
  gcloud compute ssh $instance \
	--command "sudo apt-get update && sudo apt-get install -y socat conntrack ipset && 
	wget -q --show-progress --https-only --timestamping \
	  https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz \
	  https://storage.googleapis.com/kubernetes-the-hard-way/runsc \
	  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64 \
	  https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz \
	  https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz \
	  https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl \
	  https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-proxy \
	  https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubelet &&
	  sudo mkdir -p \
		/etc/cni/net.d \
		/opt/cni/bin \
		/var/lib/kubelet \
		/var/lib/kube-proxy \
		/var/lib/kubernetes \
		/var/run/kubernetes \
		/etc/containerd &&
	  chmod +x kubectl kube-proxy kubelet runc.amd64 runsc &&
	  sudo mv runc.amd64 runc &&
	  sudo mv kubectl kube-proxy kubelet runc runsc /usr/local/bin/ &&
	  sudo tar -xvf crictl-v1.0.0-beta.0-linux-amd64.tar.gz -C /usr/local/bin/ &&
	  sudo tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/ &&
	  sudo tar -xvf containerd-1.1.0.linux-amd64.tar.gz -C / &&
	  sudo mv ${instance}-key.pem ${instance}.pem /var/lib/kubelet/ &&
	  sudo mv ${instance}.kubeconfig /var/lib/kubelet/kubeconfig &&
	  sudo mv ca.pem /var/lib/kubernetes/ &&
	  sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig &&
	  sudo bash config-worker.sh &&
	  sudo systemctl daemon-reload &&
	  sudo systemctl enable containerd kubelet kube-proxy &&
	  sudo systemctl start containerd kubelet kube-proxy"
}


kubelab::provision::worker::setup() {
  for instance in worker-{0,1,2}; do
	kubelab::provision::worker::setupworker $instance
  done
}

kubelab::provision::worker::setupworker "worker-2"