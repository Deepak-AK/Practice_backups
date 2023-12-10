#!/bin/bash

user=$1
pass=$2

oldpods="$(oc get pod -n openshift-authentication -o name)"

secret=$(oc get oauth cluster \
    -o jsonpath='{.spec.identityProviders[0].htpasswd.fileData.name}')
tmpdir=$(mktemp -d)
oc extract secret/$secret -n openshift-config \
    --keys htpasswd --to $tmpdir
htpasswd -b $tmpdir/htpasswd $user $pass
oc set data secret/$secret --from-file htpasswd=$tmpdir/htpasswd \
    -n openshift-config

rm -rf $tmpdir

oc wait co/authentication --for condition=Progressing --timeout 90s

oc rollout status deployment oauth-openshift -n openshift-authentication \
    --timeout 90s

oc wait $oldpods -n openshift-authentication --for delete --timeout 90s

oc login -u $user -p $pass --kubeconfig /dev/null \
    https://api.ocp4.example.com:6443
