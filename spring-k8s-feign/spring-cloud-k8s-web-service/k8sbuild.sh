#!/bin/bash

mvn clean install -Dmaven.test.skip=true -Dspring.profile=dev -Pk8s
