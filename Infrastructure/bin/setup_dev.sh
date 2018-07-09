#!/bin/bash
# Setup Development Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Development Environment in project ${GUID}-parks-dev"

# Code to set up the parks development project.

# To be Implemented by Student

oc policy add-role-to-user edit system:serviceaccount:${GUID}-jenkins:jenkins -n ${GUID}-parks-dev
oc policy add-role-to-user view --serviceaccount=default -n ${GUID}-parks-dev

DB_HOST="mongodb"
DB_USERNAME="mongodb"
DB_PASSWORD="mongodb"
DB_NAME="parks"

oc new-app mongodb-persistent --param MONGODB_DATABASE="${DB_NAME}" --param MONGODB_USER="${DB_USERNAME}" --param MONGODB_PASSWORD="${DB_PASSWORD}" --param MONGODB_ADMIN_PASSWORD="mongodb_admin_password" -n ${GUID}-parks-dev

oc new-app -f ../templates/mlbparks-dev-template.yaml \
--param DB_HOST=${DB_HOST} \
--param DB_PORT=27017 \
--param DB_USERNAME=${DB_USERNAME} \
--param DB_PASSWORD=${DB_PASSWORD} \
--param DB_NAME=${DB_NAME} \
--param GUID=${GUID} \
-n ${GUID}-parks-dev

oc new-app -f ../templates/nationalparks-dev-template.yaml \
--param DB_HOST=${DB_HOST} \
--param DB_PORT=27017 \
--param DB_USERNAME=${DB_USERNAME} \
--param DB_PASSWORD=${DB_PASSWORD} \
--param DB_NAME=${DB_NAME} \
--param GUID=${GUID} \
-n ${GUID}-parks-dev

oc new-app -f ../templates/parksmap-dev-template.yaml --param GUID=${GUID} -n ${GUID}-parks-dev

#oc new-build --binary=true --name="mlbparks" --image-stream=jboss-eap70-openshift:1.7 -n ${GUID}-parks-dev
#oc new-app ${GUID}-parks-dev/mlbparks:0.0-0 --name=mlbparks --allow-missing-imagestream-tags=true -n ${GUID}-parks-dev
#oc set triggers dc/mlbparks --remove-all -n ${GUID}-parks-dev
#oc expose dc mlbparks --port 8080 -n ${GUID}-parks-dev
#oc expose svc mlbparks -n ${GUID}-parks-dev
#oc label svc mlbparks "type=parksmap-backend" -n ${GUID}-parks-dev

# oc create configmap mlbparks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
# oc set volume dc/mlbparks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=mlbparks-config
# oc set volume dc/mlbparks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=mlbparks-config


#oc new-build --binary=true --name="nationalparks" redhat-openjdk18-openshift:1.2
#oc new-app ${GUID}-parks-dev/nationalparks:0.0-0 --name=nationalparks --allow-missing-imagestream-tags=true
#oc set triggers dc/nationalparks --remove-all
#oc expose dc nationalparks --port 8080
#oc expose svc nationalparks
#oc label svc nationalparks "type=parksmap-backend"

# oc create configmap nationalparks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
# oc set volume dc/nationalparks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=nationalparks-config
# oc set volume dc/nationalparks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=nationalparks-config

#oc policy add-role-to-user view --serviceaccount=default
#oc new-build --binary=true --name="parksmap" redhat-openjdk18-openshift:1.2
#oc new-app ${GUID}-parks-dev/parksmap:0.0-0 --name=parksmap --allow-missing-imagestream-tags=true
#oc set triggers dc/parksmap --remove-all
#oc expose dc parksmap --port 8080
#oc expose svc parksmap

# oc create configmap parksmap-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
# oc set volume dc/parksmap --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=parksmap-config
# oc set volume dc/parksmap --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=parksmap-config
