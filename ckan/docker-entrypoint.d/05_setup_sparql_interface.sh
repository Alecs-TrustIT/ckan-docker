#!/bin/bash

# Add CKANEXT SPARQL interface to the CKAN config file
echo "Loading resource views in the CKAN config file"
ckan config-tool $CKAN_INI \
    "ckanext.sparql_interface.endpoint_url = $CKANEXT__SPARQL_INTERFACE__ENDPOINT_URL" \
    "ckanext.sparql_interface.hide_endpoint_url = $CKANEXT__SPARQL_INTERFACE__HIDE_ENDPOINT_URL" \
    "ckanext.sparql_interface.query_prefixes = '$CKANEXT__SPARQL_INTERFACE__QUERY_PREFIXES'"