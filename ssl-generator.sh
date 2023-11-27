#!/bin/bash

#############################################################################
# Script name: ssl-generator.sh                                             #
# Version: 1.0.1                                                            #
# Description: generate a self-signed certificate                           #
# Author: Eng. Hashem Allaham (Syria)                                       #
# Email: hashem.allaham@gmail.com                                           #
#############################################################################


# Set the common name for the certificate
read -p "Enter the domain name: " COMMON_NAME

# Generate a private key
openssl genrsa -out $COMMON_NAME.key 2048

# Generate a certificate signing request (CSR)
openssl req -new -key $COMMON_NAME.key -out $COMMON_NAME.csr -subj "/CN=$COMMON_NAME"

# Generate a self-signed certificate
openssl x509 -req -days 365 -in $COMMON_NAME.csr -signkey $COMMON_NAME.key -out $COMMON_NAME.crt
