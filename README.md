# Module Input/Output

## Input Variable List

- name
- namespaces
- user
- group




```
openssl genrsa -out dev.key 2048

openssl req -new -key dev.key -out dev.csr -subj "/CN=dev/O=dev"


cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dev
spec:
  groups:
  - system:authenticated
  request: $(cat dev.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl get csr
kubectl certificate approve dev

kubectl get csr dev -o jsonpath='{.status.certificate}'  | base64 -d > dev.crt

cp ~/.kube/config  local-config
kubectl config set-credentials default --client-key=dev.key --client-certificate=dev.crt --embed-certs=true   --kubeconfig=local-config

kubectl config set-context default --cluster=default --user=default    --kubeconfig=local-config

```