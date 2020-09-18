# vultr-k8s

With these startup scripts you can have a single node kubernetes cluster on Vultr cloud (probably works on other infra as well).

# Usage

### Kubeadm installer

1. Create a Vultr account (This link gives you $100 https://www.vultr.com/?ref=8668618-6G)
2. Create an ssh key: https://my.vultr.com/settings/#settingssshkeys
3. Create a Startup Script: https://my.vultr.com/startup/manage/?SCRIPTID=new and copy the contents of vultr-k8s-singlenode.sh to it. This will install a single node k8s cluster using kubeadm.
4. Deploy a new server with the following parameters:
  - **Type**: Cloud Compute (or High Frequency for a faster one)
  - **Location**: Something close to your location
  - **Server Type**: Ubuntu 20.04 x64
  - **Server Size**: At least 2CPU
  - **Startup Script**: select the one you created at step #3
  - **SSH Keys**: select the one you created at #2

It takes a few minutes to create the server. At once it's ready, connect to it using SSH.
K8s deployment can be tracked in `/tmp/firstboot.log` file. At once it's finished, your cluster is ready to run commands like:

```
root@k8s:~# kubectl run --image nginx mynginx
pod/mynginx created
```
```
root@k8s:~# kubectl expose pod mynginx --type=NodePort --port=80
service/mynginx exposed
```
```
root@k8s:~# kubectl get all
NAME          READY   STATUS    RESTARTS   AGE
pod/mynginx   1/1     Running   0          7s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        17m
service/mynginx      NodePort    10.104.148.34   <none>        80:31454/TCP   2s
```
```
root@k8s:~# curl localhost:31454
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
### Microk8s installer

This script is pretty similar to the previous one. It deploys Microk8s based on https://microk8s.io/docs, so k8s will be accessible with `microk8s kubectl ...` commands.

Installation steps are the same as with kubeadm, but use `vultr-microk8s.sh` as a startup script.

# Further reading
https://k8s.io - Trust me, it's good stuff ;)
