console.log("Lambda has been triggered on Cognito Pre Authentication Event")

const handler = async (event) => {
    try {
        // Destructure event object for better readability
        const { version, region, callerContext, eventType, datasetRecords, triggerSource, userPoolId, userName, userAttributes, request, response } = event;

        // Send post authentication data to Amazon CloudWatch logs
        console.log("PreAuthenticati");
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


// Response

Event = {
    version: '1',
    region: 'us-west-1',
    userPoolId: 'us-west-1_xxxxx',
    userName: 'google_xxxxx',
    callerContext: {
      awsSdkVersion: 'aws-sdk-unknown-unknown',
      clientId: 'xxxx'
    },
    triggerSource: 'PreAuthentication_Authentication',
    request: {
      userAttributes: {
        sub: '8xxxxxxxxxxxc-9a9e40549a67',
        'cognito:user_status': 'EXTERNAL_PROVIDER',
        identities: '[{"userId":"xxxxx","providerName":"Google","providerType":"Google","issuer":null,"primary":true,"dateCreated":1704883569945}]',
        email_verified: 'true',
        given_name: 'Dmitri',
        family_name: 'Konnov',
        email: 'dmitri.v.konnov@gmail.com',
        picture: 'https://lh3.googleusercontent.com/a/ACg8ocJ4rsrAHQjCrTotXS8G1SOjjwRRiL9QVCfKDX0rVW37DA=s96-c'
      },
      validationData: {}
    },
    response: {}
  }