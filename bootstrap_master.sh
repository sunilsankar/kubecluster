#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
#kubeadm init --apiserver-advertise-address=192.168.30.200 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null
kubeadm init --apiserver-advertise-address=192.168.30.200 --pod-network-cidr=172.16.0.0/16 >> /root/kubeinit.log 2>/dev/null
# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy Flannel network
#echo "[TASK 3] Deploy flannel network"
#su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml"

# Deploy Flannel network
echo "[TASK 3] Deploy weave network"
su - vagrant -c "kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.NO_MASQ_LOCAL=1""

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Configure MetalLB
echo "[TASK 5] MetalLB strict"
su - vagrant -c "kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system"
su - vagrant "kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml"
su - vagrant -c "kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)""
su - vagrant -c "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.30.20-192.168.30.50
"
