#!/bin/bash

IPS=$(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service == "CLOUDFRONT") | .ip_prefix')
jq -n --arg ips "$IPS" '{"cloudfront_ips":$ips}'

