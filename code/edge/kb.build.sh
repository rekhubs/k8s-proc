#!/usr/bin/env bash


image='my-tradev/edge-service'
depl='edge-depl-test'
service='edge-svc-test'
envir='localdev'

echo -e "\n############# Step 1 - git pull #################"
# git pull

echo -e "\n############# Step 2 - build Java/Spring app and package #################"
# mvn package && java -jar target/package-name-0.1.0.jar
mvn package

echo -e "\n############# Step 3 - build docker image #################"
# docker build -t $image .
docker build \
  --build-arg http_proxy=http://xxx@my.proxy.network.nz:9400\
   --build-arg https_proxy=http://xxx@my.proxy.network.nz:9400\
   -t $image .

echo -e "\n############# Step 4 - export docker image #################"
docker save $image > edge.docker.image.tar

echo -e "\n############# Step 5 - import image into microk8s #################"
microk8s ctr image import  edge.docker.image.tar

echo -e "\n############# Step 6 - delete service and deployment #################"
# use rollout restart if just to update image
# microk8s kubectl rollout restart deployment/$depl

microk8s kubectl delete svc/$service
sleep 5
microk8s kubectl delete deployment/$depl
sleep 5

echo -e "\n############# Step 7 - deploy #################"
# microk8s kubectl apply -f kb.edge.depl.yaml
microk8s kubectl apply -f kb.edge.service.yaml

# echo -e "\n############# Step 8 - forward port #################"
# # pkill microk8s -9
# ps -ef | grep port-forward | grep 9443:443
# # kill $(ps -ef | grep port-forward | grep 9443:443 | awk '{print $2}')
# ps -ef | grep port-forward | grep 9443:443 | awk '{print $2}'| xargs kill -9
# sleep 5
# nohup microk8s kubectl port-forward deployment/edge-depl-test --address 0.0.0.0  9443:443  &

echo -e "\n#################### finished. ##########################"
exit 0;

