#! /bin/bash

set -o errexit # exit on errors
set -o nounset # exit on use of uninitialized variable

CLUSTER=stable-cluster-1

if [ $# -eq 0 ]; then
    echo "Defaulting to cloud stable instance"
fi

while [[ $# -gt 0 ]]; do
    key="$1"
    shift
    # shifts to skip ... --{arg} {val} ...
    case $key in
    stable)
        CLUSTER=stable-cluster-1
        echo Connecting to cloud stable instance
        ;;
    dev)
        echo Connecting to cloud dev instance
        CLUSTER=meditech-cluster-1
        ;;
    -*)
        echo ERROR - unknown option: $key
        displayHelp
        exit 1
        ;;
    *)
        echo ERROR - unknown argument: $key
        displayHelp
        exit 1
        ;;
    esac
done

gcloud container clusters get-credentials $CLUSTER --zone us-east4-b --project cloud-services-dev
kubectl port-forward svc/rest-appserver 8081:8081 &
APP_PF_PID=$!
echo Application Port Forwarding Process ID: $APP_PF_PID
kubectl port-forward svc/rest-apiserver 8080:8080 &
API_PF_PID=$!
echo API Port Forwarding Process ID: $API_PF_PID
wait
kill $APP_PF_PID
kill $API_PF_PID
