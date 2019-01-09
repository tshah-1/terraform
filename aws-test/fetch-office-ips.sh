#!/bin/bash

IPS=$(bash process-office-ips.sh) 
jq -n --arg ips "$IPS" '{"office_ips":$ips}'
