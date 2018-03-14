#!/usr/bin/env bash

set -x

# auth
sfdx force:auth:jwt:grant --clientid $CONSUMERKEY --jwtkeyfile $JWTKEYFILE --username $USERNAME --setdefaultdevhubusername -a HubOrg

# Create or org
sfdx force:org:create -v HubOrg -s -f config/project-scratch-def.json -a ciorg --loglevel trace

if [ $? -ne 0 ]; then
    bunyan ~/.sfdx/sfdx.log
    exit 1
fi

# push source
sfdx force:source:push -u ciorg && sfdx force:apex:test:run -u ciorg -c -r human

# delete the org
sfdx force:org:delete -u ciorg -p
