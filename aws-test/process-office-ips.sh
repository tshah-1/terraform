#!/bin/bash

IPS=$(bash fetch-office-ips.sh) 
jq -n --arg ips "$IPS" '{"office_ips":$ips}'
