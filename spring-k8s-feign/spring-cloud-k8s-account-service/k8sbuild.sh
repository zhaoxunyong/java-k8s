#!/bin/bash

mvn clean install -Dmaven.test.skip=true -Dspring.profile=dev -Pk8s
# mvn clean install k8s:build k8s:push k8s:resource k8s:apply -Dmaven.test.skip=true -Dspring.profile=dev -Pk8s
