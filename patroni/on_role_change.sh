#!/usr/bin/env sh

echo "ARGUMENTS"
echo $@

NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
API_URL=https://kubernetes.default.svc.cluster.local/api/v1

# get all masters
# get code -s -o -I -L -w "%{http_code}"
ROLE_LABEL_MASTER=$(curl -s --cacert ${CA_BUNDLE} \
   -H "Authorization: Bearer ${TOKEN}" \
   ${API_URL}/namespaces/${NAMESPACE}/pods\?labelSelector=role\=master,app\=pg-postgres)

echo "ROLE_LABEL_MASTER = ${ROLE_LABEL_MASTER}"