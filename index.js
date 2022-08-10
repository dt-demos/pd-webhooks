const { default: axios } = require('axios');

exports.handler = async (event) => {
  if (event.requestContext.http.method != 'POST') {
    return { statusCode: 200, body: 'ok' };
  }
  let pdIncidentId,dtPid,pdIncidentUrl;
  try {
    const body = JSON.parse(event.body);
    pdIncidentId = body.event.data.incident.id;
    pdIncidentUrl = body.event.data.incident.html_url;
    dtPid = '8857294971831621162_1658883180000V2';
  } catch (e) {
    return { statusCode: 200, body: 'Error parsing PagerDuty webhook body' };
  }

  let dtBaseUrl,dtApiToken,dtBody,r;
  try {
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
