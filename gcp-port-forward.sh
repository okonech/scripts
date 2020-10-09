#! /bin/bash
gcloud container clusters get-credentials meditech-cluster-1 --zone us-east4-b --project cloud-services-dev
kubectl port-forward svc/rest-appserver 8081:8081 &
APP_PF_PID=$!
echo Application Port Forwarding Process ID: $APP_PF_PID
kubectl port-forward svc/rest-apiserver 8080:8080 &
API_PF_PID=$!
echo API Port Forwarding Process ID: $API_PF_PID
wait
kill $APP_PF_PID
kill $API_PF_PID
