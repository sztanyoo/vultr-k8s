#!/bin/sh

set -x

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

apt update
apt install -y docker.io
systemctl enable docker.service

sudo sysctl --system

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
kubeadm init

DEFAULT_KUBECONFIG=/etc/kubernetes/admin.conf

mkdir -p /root/.kube
cp -i $DEFAULT_KUBECONFIG /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

echo "Deploy networking"
kubectl --kubeconfig $DEFAULT_KUBECONFIG apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

echo "Enable scheduling to master"
kubectl --kubeconfig $DEFAULT_KUBECONFIG taint node `hostname` node-role.kubernetes.io/master:NoSchedule-
kubectl --kubeconfig $DEFAULT_KUBECONFIG taint node `hostname` node.kubernetes.io/not-ready:NoSchedule-

wall "Bootstrap ready"

