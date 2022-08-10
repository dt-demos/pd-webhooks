const { default: axios } = require('axios');

exports.handler = async (event) => {

  // parse the PD webhook payload and pull out the PD incident ID
  if (event.requestContext.http.method != 'POST') {
    return { statusCode: 200, body: 'ok' };
  }
  let pdIncidentId,pdIncidentUrl,pdApiAccessKey;
  try {
    pdApiAccessKey = process.env.PD_API_ACCESS_KEY;
    const body = JSON.parse(event.body);
    pdIncidentId = body.event.data.incident.id;
    pdIncidentUrl = body.event.data.incident.html_url;
  } catch (e) {
    return { statusCode: 200, body: 'Error parsing PagerDuty webhook body' };
  }

  // get the alert details for the PD incident ID
  // this will have the Dynatrace problem ID
  let alert,r;
  try {
    r = await axios.request({
      url: `https://api.pagerduty.com/incidents/${pdIncidentId}/alerts`,
      method: 'GET',
      headers: {
        'Authorization': `Token token=${pdApiAccessKey}`,
        'Accept': 'application/vnd.pagerduty+json;version=2',
        'Content-Type': 'application/json'
      }
    }); 
    alert = r.data.alerts[0];
  } catch (e) {
    return ({
      statusCode: 200,
      body: `Couldn't get alert details from incident ${pdIncidentId}`
    });
  }

  // Setup the variables needed to add the Dynatrace comment
  let dtBaseUrl,dtApiToken,dtBody,dtPid;
  try {
    dtPid = alert.body.details.ProblemID;
    dtBaseUrl = process.env.DT_BASE_URL;
    dtApiToken = process.env.DT_API_TOKEN;  
    dtBody = {
      "message": `Opened PD Incident [${pdIncidentId}](${pdIncidentUrl})`,
      "context": "pd-webhook"
    };

  } catch (e) {
    return ({
      statusCode: 200,
      body: 'Error building Dynatrace problem comment request body'
    });
  }

  // Add the Dynatrace comment using the Dynatrace problem ID
  try {
    r = await axios.request({
      url: `${dtBaseUrl}/api/v2/problems/${dtPid}/comments`,
      method: 'POST',
      headers: {
        'Authorization': `Api-Token ${dtApiToken}`,
        'Content-Type': 'application/json'
      },
      data: JSON.stringify(dtBody),
    });  
  } catch (e) {
    return ({
      statusCode: 200,
      body: 'Error adding Dynatrace problem comment'
    })
  }

  return ({
    statusCode: 200,
    body: `Dynatrace problem comment response code ${r.status}`
  });
};
