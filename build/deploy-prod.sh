#Convert to MDAPI format for deployment to prod
#Despliegue a pruebasCI
echo "Converting to MDAPI format..."
sfdx force:org:list
echo "Command - sfdx force:mdapi:retrieve -r packageRoles -u my-hub-orgPruebasCI -k packageRoles/package.xml"
sfdx force: mdapi:convert -d deploy_prod -r pruebaPackage
sfdx config:set defaultusername=consultor_force+amicar@nectia.com.pruebasci
sfdx force:mdapi:deploy -c -d pruebaPackage -u my-hub-orgPruebasCI -w 10 #-l RunSpecifiedTests -r AMICAR_ChecklistGetJSONTest -w 33 --verbose --loglevel fatal

#Despliegue producción
#echo "Command - sfdx force:mdapi:retrieve -r packageRoles -u my-hub-Prod -k packageRoles/package.xml"
#sfdx force: mdapi:convert -d deploy_prod -r pruebaPackage
#sfdx config:set defaultusername=consultor_force+amicar@nectia.com
#sfdx force:mdapi:deploy -c -d pruebaPackage -u my-hub-Prod -w 10 #-l RunSpecifiedTests -r AMICAR_ChecklistGetJSONTest -w 33 --verbose --loglevel fatal
