#!/bin/bash
# Setup Production Project (initial active services: Green)
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Production Environment in project ${GUID}-parks-prod"

# Code to set up the parks production project. It will need a StatefulSet MongoDB, and two applications each (Blue/Green) for NationalParks, MLBParks and Parksmap.
# The Green services/routes need to be active initially to guarantee a successful grading pipeline run.

# To be Implemented by Student

oc policy add-role-to-user edit system:serviceaccount:${GUID}-jenkins:jenkins -n ${GUID}-parks-prod
oc policy add-role-to-group system:image-puller system:serviceaccounts:${GUID}-parks-prod -n ${GUID}-parks-dev
oc policy add-role-to-user view --serviceaccount=default -n ${GUID}-parks-prod

DB_HOST="mongodb"
DB_USERNAME="mongodb"
DB_PASSWORD="mongodb"
DB_NAME="parks"
DB_REPLICASET="rs0"

#oc new-app mongodb-persistent --param MONGODB_DATABASE="${DB_NAME}" --param MONGODB_USER="${DB_USERNAME}" --param MONGODB_PASSWORD="${DB_PASSWORD}" --param MONGODB_ADMIN_PASSWORD="mongodb_admin_password" -n ${GUID}-parks-dev

oc new-app -f ../templates/mlbparks-prod-template.yaml \
--param DB_HOST=${DB_HOST} \
--param DB_PORT=27017 \
--param DB_USERNAME=${DB_USERNAME} \
--param DB_PASSWORD=${DB_PASSWORD} \
--param DB_NAME=${DB_NAME} \
--param DB_REPLICASET=${DB_REPLICASET} \
--param GUID=${GUID} \
-n ${GUID}-parks-prod

oc new-app -f ../templates/nationalparks-prod-template.yaml \
--param DB_HOST=${DB_HOST} \
--param DB_PORT=27017 \
--param DB_USERNAME=${DB_USERNAME} \
--param DB_PASSWORD=${DB_PASSWORD} \
--param DB_NAME=${DB_NAME} \
--param DB_REPLICASET=${DB_REPLICASET} \
--param GUID=${GUID} \
-n ${GUID}-parks-prod

oc new-app -f ../templates/parksmap-prod-template.yaml --param GUID=${GUID} -n ${GUID}-parks-prod
