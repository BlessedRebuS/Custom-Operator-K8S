# custom-operator
In questa repository si implementa un custom gitlab runner operator configurato per fare il runner di una istanza gitlab che gira anche essa riconciliata da un operator.

## Installare il classico gitlab operator

```bash
mkdir gitlab
cd gitlab
helm install gitlab-operator gitlab/gitlab-operator --create-namespace --namespace gitlab-system
```

```bash
kubectl get services -n gitlab-system 
```

Creare la entry nel file /etc/host del cluster e della macchina da cui si vuole raggiungere l'istanza

echo "192.168.1.155	gitlab.test.local" >> /etc/hosts

Si dovrà poi aggiungere l' host sfruttando il DNS del cluster direttamente nella definizione della risorsa Runner

```yaml
hostAliases:
  - ip: "192.168.1.155"
    hostnames:
    - "gitlab.test.local"
```

In questo modo il runner conoscerà **gitlab.test.local** e considererà i suoi certificati come validi

![image info](img/services.png)

```bash
openssl s_client -showcerts -connect test-gitlab.local:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > gitlab.crt

openssl x509 -in gitlab.crt -text -noout
```

Creare il secret basato sul file crt di gitlab per verificare l'identità del server

```bash
kubectl create secret generic gitlab-cert -n runner-system --from-file=gitlab.crt
```


## Customizzare il runner tramite operator-sdk

```bash
mkdir runner
cd runner
operator-sdk init --plugins=helm --domain=gitlab.com --group=apps --version=v1beta1 --kind=GitLab --helm-chart=gitlab/gitlab-operator
make install
export IMG=docker.io/blessedrebus/gitlab-operator:v0.0.1
make docker-build docker-push IMG=$IMG
make deploy IMG=$IMG
k apply -f crd.yaml -n gitlab-system
```

