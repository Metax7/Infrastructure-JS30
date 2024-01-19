console.log('Loading function');

const handler = async (event) => {
    try {
        // Destructure event object for better readability
        const { userAttributes, newDeviceUsed } = request
        const { version, region, callerContext, eventType, datasetRecords, triggerSource, userPoolId, userName, request, response } = event;

        // Send post authentication data to Amazon CloudWatch logs
        console.log("Authentication successful");
        console.log("Event =", event);
        console.log("Version =", version);
        console.log("Region =", region);
        console.log("Caller context =", callerContext);
        console.log("Event type =", eventType);

        // Check if datasetRecords is defined
        if (datasetRecords !== undefined) {
            console.log("DataSet records =", datasetRecords);
        }

        console.log("Trigger source =", triggerSource);
        console.log("User pool = ", userPoolId);
        console.log("App client ID = ", callerContext.clientId);
        console.log("User name = ", userName);
        console.log("User attributes =", userAttributes);
        console.log("Request =", request);
        console.log("Response =", response);

        return event;
    } catch (error) {
        // Handle errors gracefully
        console.error("Error:", error);
        throw error;
    }
};

export { handler };

// logged event in JSON

Event = {
    version: '1',
    region: 'us-west-1',
    userPoolId: 'us-west-1_xxxx',
    userName: 'google_xxxx',
    callerContext: {
      awsSdkVersion: 'aws-sdk-unknown-unknown',
      clientId: '1rq65aa26xxxxxxxxxxx'
    },
    triggerSource: 'PostAuthentication_Authentication',
    request: {
      userAttributes: {
        sub: '44a8dfc5-28b7-4c2c-xxxxxxxxxxxxxxe',
        email_verified: 'true',
        identities: '[{"userId":"102xxxxxxxxxxxx","providerName":"Google","providerType":"Google","issuer":null,"primary":true,"dateCreated":1704481562273}]',
        'cognito:user_status': 'EXTERNAL_PROVIDER',
        address: 'xxxxxxxx',
        given_name: 'Dmitri',
        'custom:google_access_token': 'xxxxxxxxxxx',
        family_name: 'Konnov',
        picture: 'https://lh3.googleusercontent.com/a/ACg8ocJ4rsrAHQjCrTotXS8G1SOjjwRRiL9QVCfKDX0rVW37DA=s96-c',
        email: 'dmitri.v.konnov@gmail.com'
      },
      newDeviceUsed: false
    },
    response: {}
  }