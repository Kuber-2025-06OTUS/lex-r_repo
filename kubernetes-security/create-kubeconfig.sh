#!/bin/bash

set -eo pipefail

USER=cd
NAMESPACE=homework
SECRET=cd-token
CLUSTER_ADDR=https://127.0.0.1:55076
CLUSTER_NAME=colima
CONTEXT=${CLUSTER_NAME}

# create a secret with type kubernetes.io/service-account-token
# for service account "cd" in namespace "homework"
kubectl apply -f secret-cd.yaml

# get the token from the secret and decode it
TOKEN=$(kubectl -n ${NAMESPACE} get secret ${SECRET} \
  --template={{.data.token}} | base64 --decode)

CA_CRT=$(kubectl -n homework get secret cd-token -o jsonpath='{.data.ca\.crt}')

cat << EOF > kubeconfig-for-cd
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CA_CRT
    server: $CLUSTER_ADDR
  name: $CLUSTER_NAME
contexts:
- context:
    cluster: $CLUSTER_NAME
    namespace: $NAMESPACE
    user: $USER
  name: $CONTEXT
current-context: "$CONTEXT"
kind: Config
preferences: {}
users:
- name: $USER
  user:
    token: $TOKEN
EOF