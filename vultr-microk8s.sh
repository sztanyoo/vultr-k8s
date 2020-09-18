#!/bin/sh

set -x

snap install microk8s --classic
usermod -a -G microk8s root
chown -f -R root ~/.kube

microk8s status --wait-ready
microk8s enable dashboard dns registry fluentd

token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

cd /root
mkdir .kube
cd .kube
microk8s config > config

wall "Bootstrap ready"

