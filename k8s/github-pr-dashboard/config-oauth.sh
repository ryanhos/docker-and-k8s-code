#!/usr/bin/env bash

echo "Enter the client ID"
read CLIENT_ID

echo "Enter the client secret"
read CLIENT_SECRET

COOKIE_SECRET=`python -c 'import os,base64; print base64.b64encode(os.urandom(16))'`

sed -i -e "s|##COOKIE_SECRET##|${COOKIE_SECRET}|g" add-oauth.yaml
sed -i -e "s|##CLIENT_ID##|${CLIENT_ID}|g" add-oauth.yaml
sed -i -e "s|##CLIENT_SECRET##|${CLIENT_SECRET}|g" add-oauth.yaml
