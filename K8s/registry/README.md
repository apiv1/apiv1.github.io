### Deploy

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
### client: daemon.json
```
{
  "insecure-registries": ["<ip>"],
  ...
}
```

### registry secret
```bash
kubectl delete secret docker.deploy
kubectl create secret docker-registry docker.deploy --docker-server=$REGISTRY_SERVER --docker-username=$REGISTRY_USERNAME --docker-password=$REGISTRY_PASSWORD
```