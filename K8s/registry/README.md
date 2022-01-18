### Deploy (on server)

```bash
alias htpassgen='htpasswd -Bbn'
alias htpassgen='docker run --rm -i httpd:2 htpasswd -Bbn'
alias htpassgen='kubectl run --rm -i --image=httpd:2 --restart=Never -q htpasswd -- htpasswd -Bbn'
# 3 choose 1

# install
kubectl apply -f https://apiv1.github.io/note/K8s/registry/deployment.yml # optional
# or
kubectl apply -f deployment.yml

# set REGISTRY_USER, REGISTRY_PASSWORD
kubectl exec -it deploy/registry -- sh -c "echo '$(htpassgen $REGISTRY_USERNAME $REGISTRY_PASSWORD)' > /auth/htpasswd"
kubectl rollout restart deploy/registry
```

### setting image.registry ip (on client)
```bash
sed -i "/.*#.*SETTING.*image\.registry.*/d" /etc/hosts
echo $IMAGE_REGISTRY_IP' image.registry # SETTING: image.registry' >> /etc/hosts
```

set `image.registry` as registry ip

### daemon.json (for docker, on client)
```
{
  "insecure-registries": ["image.registry"],
  ...
}
```

### registry secret (for k8s)
```bash
REGISTRY_SERVER=image.registry # default
kubectl delete secret image.registry.secret
kubectl create secret docker-registry image.registry.secret --docker-server=$REGISTRY_SERVER --docker-username=$REGISTRY_USERNAME --docker-password=$REGISTRY_PASSWORD
```
#### using secret
```yaml
    spec:
      imagePullSecrets:
        - name: image.registry.secret
```

### private-registry (for k3s server)
from [https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/](https://docs.rancher.cn/docs/k3s/installation/private-registry/_index/)<br>

registries.yaml
```
mirrors:
  "image.registry":
    endpoint:
      - "http://image.registry"
configs:
  "image.registry":
    auth:
      username: $USERNAME
      password: $PASSWORD
```