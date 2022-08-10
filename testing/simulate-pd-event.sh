#!/bin/bash

echo "============================================================="
echo "Sending PD event"
echo "============================================================="
#read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

mkdir -p ".logs"
CURL_OUTPUT_FILE=".logs/pd-ouput.txt"
PROBLEM=$(date "+%Y-%m-%d--%H.%M.%S")
PROBLEM_TITLE="Simulated Dynatrace problem $PROBLEM"

# this is the format that comes from Dynatrace
PAYLOAD='
{
  "dedup_key": "'$PROBLEM'",
  "event_action": "trigger",
  "routing_key": "'$PD_ROUTING_KEY'",
  "payload": {
    "summary": "'$PROBLEM_TITLE'",
    "source": "Dynatrace",
    "client": "dynatrace",
    "severity": "critical",
    "client_url": "https://example.com",
    "class": "INFRASTRUCTURE",
    "custom_details": {
      "incident_key": "'$PROBLEM'",
      "ProblemID": "'$PROBLEM'",
      "hostname": "Myhost1, Myservice1",
      "event_storage_id": "Myhost1, Myservice1",
      "State": "OPEN",
      "ProblemTitle": "Dynatrace problem notification test run",
      "Problem Details HTML": "<h1>Dynatrace problem notification test run details</h1>",
      "Problem Details JSON": {
        "id": "'$PROBLEM'"
      },
      "Impact": "INFRASTRUCTURE",
      "Tags": "testtag1:testvalue, testtag2"
    }
  }
}'

echo "=============================================================="
echo "SENDING THE FOLLOWING HTTP PAYLOAD"
echo "=============================================================="
echo $PAYLOAD | jq 
echo "=============================================================="

curl -X POST \
  "https://events.pagerduty.com/v2/enqueue" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" \
  -o $CURL_OUTPUT_FILE

echo "API RESPONSE:"
echo "=============================================================="
cat $CURL_OUTPUT_FILE
echo ""
echo ""
