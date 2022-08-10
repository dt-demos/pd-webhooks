#!/bin/bash

if [ -z $LAMBDA_URL ]; then
    echo "LAMBDA_URL is required environment variable"
    exit 1
fi

echo "Calling $LAMBDA_URL"
echo ""

curl -X POST "$LAMBDA_URL" \
    -H "Content-Type: application/json" \
    --data-raw '
{
  "event": {
    "id": "01D3NPB0KYNC9XDDNP47UN2NMC",
    "event_type": "incident.annotated",
    "resource_type": "incident",
    "occurred_at": "2022-08-10T02:14:27.865Z",
    "agent": {
      "html_url": "https://dev-dt-demos.pagerduty.com/users/PBC5J6U",
      "id": "PBC5J6U",
      "self": "https://api.pagerduty.com/users/PBC5J6U",
      "summary": "rob jahn",
      "type": "user_reference"
    },
    "client": null,
    "data": {
      "incident": {
        "html_url": "https://dev-dt-demos.pagerduty.com/incidents/Q20WG3R393D6M9",
        "id": "Q20WG3R393D6M9",
        "self": "https://api.pagerduty.com/incidents/Q20WG3R393D6M9",
        "summary": "Simulated Dynatrace problem 2022-08-09--21.21.44",
        "type": "incident_reference"
      },
      "id": "PG1HV14",
      "content": "test",
      "trimmed": false,
      "type": "incident_note"
    }
  }
}
'

echo ""