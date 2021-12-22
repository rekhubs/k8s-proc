#!/usr/bin/env bash

image='my-tradev/discovery-service'
depl='discovery-depl-test'
statefulSet='discovery-ss-test'
svc='discovery-svc-test'
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
docker save $image > disco.docker.image.tar

echo -e "\n############# Step 5 - import image into microk8s #################"
microk8s ctr image import  disco.docker.image.tar

echo -e "\n############# Step 6 - delete deployment #################"
microk8s kubectl delete deployment/$depl
sleep 5
microk8s kubectl delete statefulSet/$ss
sleep 5
microk8s kubectl delete service/$svc
sleep 5

echo -e "\n############# Step 7 - deploy #################"
# microk8s kubectl apply -f kb.discovery.depl.yaml
# microk8s kubectl apply -f kb.discovery.service.yaml
microk8s kubectl apply -f kb.discovery.stateful.svc.yaml

echo -e "\n#################### finished. ##########################"
exit 0;

