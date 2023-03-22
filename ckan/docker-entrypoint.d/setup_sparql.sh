#!/bin/bash

# Update ckanext-sparql settings defined in the env var
echo "Loading ckanext-sparql settings into ckan.ini"
ckan config-tool $CKAN_INI \
    "ckanext.sparql.endpoint_url=$CKANEXT__SPARQL__ENDPOINT_URL" \
    "ckanext.sparql.hide_endpoint_url=$CKANEXT__SPARQL__HIDE_ENDPOINT_URL" 