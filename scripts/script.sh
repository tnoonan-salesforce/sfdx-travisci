#!/usr/bin/env bash

set -x
export HTTP_PROXY=http://ec2-34-201-92-203.compute-1.amazonaws.com:8080
export HTTPS_PROXY=http://ec2-34-201-92-203.compute-1.amazonaws.com:8080
# auth
sfdx force:auth:jwt:grant --clientid $CONSUMERKEY --jwtkeyfile $JWTKEYFILE --username $DEVHUB_USERNAME --setdefaultdevhubusername -a HubOrg --dev-debug

# Create or org
sfdx force:org:create -v HubOrg -s -f config/project-scratch-def.json -a ciorg --dev-debug

if [ $? -ne 0 ]; then
    bunyan ~/.sfdx/sfdx.log
    exit 1
fi

# push source
sfdx force:source:push -u ciorg && sfdx force:apex:test:run -u ciorg -c -r human --dev-debug

# delete the org
sfdx force:org:delete -u ciorg -p
