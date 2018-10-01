#!/bin/bash
# Setup Nexus Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Nexus in project $GUID-nexus"

#
# Create objects
#
oc project $GUID-nexus
oc process -f Infrastructure/templates/nexus.yaml -p GUID=${GUID} | oc create -f -

#
# wait for nexus
#
set -x
NEXUS_URL=$(oc get route nexus3 --template='{{ .spec.host }}' -n ${GUID}-nexus)/service/metrics/ping
until  curl --fail  -u admin:admin123 ${NEXUS_URL}; do
  echo "."
  sleep 10
done
#while : ; do
#    oc get pod -n ${GUID}-nexus | grep '\-1\-' | grep -v deploy | grep "1/1"
#    if [ $? == "1" ] 
#      then 
#        sleep 10
#      else 
#        break 
#    fi
#done

#
# Configure Nexus
#
curl -o setup_nexus3.sh -s https://raw.githubusercontent.com/wkulhanek/ocp_advanced_development_resources/master/nexus/setup_nexus3.sh
chmod +x setup_nexus3.sh

sh setup_nexus3.sh admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}' -n ${GUID}-nexus )
rm -f setup_nexus3.sh


