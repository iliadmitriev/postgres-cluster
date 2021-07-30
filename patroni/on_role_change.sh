#!/usr/bin/env sh

NEW_ROLE=$2

test -z $NEW_ROLE && { echo "NEW_ROLE is empty" ; exit 1; }

NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
API_URL=https://kubernetes.default.svc.cluster.local/api/v1

case $NEW_ROLE in
"master")
  # add label
  RES=$(curl -s -o -I -L -w "%{http_code}" --cacert $CA_BUNDLE \
     -H "Authorization: Bearer $TOKEN" \
     $API_URL/namespaces/$NAMESPACE/pods/$(hostname) \
     -XPATCH -H 'Content-type: application/merge-patch+json' \
     -d '{"metadata":{"labels":{"role":"master"}}}')

  ;;
"replica")
  # delete label
  RES=$(curl -s -o -I -L -w "%{http_code}" --cacert $CA_BUNDLE \
     -H "Authorization: Bearer $TOKEN" \
     $API_URL/namespaces/$NAMESPACE/pods/$(hostname) \
     -XPATCH -H 'Content-type: application/merge-patch+json' \
     -d '{"metadata":{"labels":{"role":null}}}')
  ;;
*)
  echo "$(date -Iseconds): Failed to change label role - unknown role $NEW_ROLE"
  RES=0
  exit
  ;;
esac

if [ $RES -eq 200 ];
then
  echo "$(date -Iseconds): Changed label role for pod to=$NEW_ROLE"
else
  echo "$(date -Iseconds): Failed to change label role for pod to=$NEW_ROLE with code $RES"
fi