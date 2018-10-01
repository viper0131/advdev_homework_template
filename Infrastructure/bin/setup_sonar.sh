#!/bin/bash
# Setup Sonarqube Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Sonarqube in project $GUID-sonarqube"

#
# Create objects
#
oc project $GUID-sonarcube
oc process -f Infrastructure/templates/sonar.yaml -p GUID=${GUID} | oc create -f -

