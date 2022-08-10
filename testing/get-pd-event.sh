#!/bin/bash

INCIDENTID=Q13F9AFE29EY9B

echo "Get detail for INCIDENT $INCIDENTID"
echo ""

curl -s -X GET \
  "https://api.pagerduty.com/incidents/$INCIDENTID/alerts" \
  -H "Accept: application/vnd.pagerduty+json;version=2" \
  -H "Authorization: Token token=$PD_API_TOKEN" \
  -H "Content-Type: application/json" | jq

echo ""