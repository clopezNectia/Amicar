#sfdx force:auth:web:login -a $SFDC_UAT_USER -r https://test.salesforce.com/ -s
#sfdx force:source:push -u ${CIRCLE_BRANCH}
sfdx force:org:list
sfdx force:apex:test:run -u my-hub-orgPruebasCI -w 10 -l RunSpecifiedTests -r AMICAR_ChecklistGetJSONTest -w 33 --verbose --loglevel fatal
#my-hub-Dodoria

