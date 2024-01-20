import { randomBytes } from 'crypto';
import { SSMClient, PutParameterCommand } from "@aws-sdk/client-ssm";
import AWSXRay from 'aws-xray-sdk-core';

const ENCODING_SCHEME = 'base64';
const KEY_SIZE = 32; // 256 bits
const CIPHER_KEY_FULLNAME = "/sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";
const ssmClient = AWSXRay.captureAWSv3Client (new SSMClient({ region: process.env.AWS_DEFAULT_REGION }));


/**
 * Lambda function handler for key rotation.
 *
 * @param {Object} event - The event object triggering the Lambda function.
 * @param {Object} context - The context object containing information about the execution environment.
 *
 */
export const handler = async (event, context) => {

    if(!isValid(event)){
        console.error("Event not processed.")
        return context.logStreamName
    }
    const newKey = generateCipherkey();
    // 2. Update current cipher key
    try {
        const response = await updateCurrentCipherkey(newKey);
        // console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2))
        console.info("EVENT PROCESSED\n" + JSON.stringify(event, null, 2))
        // return context.logStreamName
        return response;
    }
    catch (error){
        console.error("Event not processed: ", error)
        throw error;
    }
};


/**
 * Update the current cipher key.
 *
 * @param {string} newKey - The new cipher key material.
 */
const updateCurrentCipherkey = async (newKey) => {

    const input = {
        Name: CIPHER_KEY_FULLNAME,
        Value: newKey,
        Overwrite: true,
    };
    const command = new PutParameterCommand(input);

    try {
        const response =  await ssmClient.send(command);
        return response.data;
    }
    catch (error) {
        handleSSMError(error);
    }

};

/**
 * Generate a new cipher key.
 *
 * @returns {String} - A Promise that resolves to the new cipher key material.
 */
const generateCipherkey = () => {
    const cipherkey = randomBytes(KEY_SIZE);
    return cipherkey.toString(ENCODING_SCHEME);
};


/**
 *  {Object} event - {
 *   "version": "0",
 *   "id": "6a7e8feb-b491-4cf7-a9f1-bf3703467718",
 *   "detail-type": "Parameter Store Policy Action",
 *   "source": "aws.ssm",
 *   "account": "123456789012",
 *   "time": "2017-05-22T16:43:48Z",
 *   "region": "us-east-1",
 *   "resources": ["arn:aws:ssm:us-east-1:123456789012:parameter/foo"],
 *   "detail": {
 *     "policy-type": "NoChangeNotification",
 *     "parameter-name": "foo",
 *     "parameter-type": "String",
 *     "policy-content": "{\"Type\":\"NoChangeNotification\",\"Version\":\"1.0\",\"Attributes\":{\"After\":\"2\",\"Unit\":\"Hours\"}}",
 *     "action-status": "Success",
 *     "action-reason": "The parameter has not been changed for 2 hours. This notification was generated based on the policy created at 2018-02-05T20:26:18.795Z"
 *   }
 * }
 * */

/**
 * Check if the 'resources' property is present and ends with `${CIPHER_KEY_FULLNAME}`.
 *
 * @param {Object} event - The event object.
 * @returns {boolean} - True if the condition is met, false otherwise.
 */
const isValid = (event) => {
    if (event.resources && Array.isArray(event.resources) && event.resources.length > 0) {
        const resourceName = event.resources[0];
        const expectedResourceSuffix = `${CIPHER_KEY_FULLNAME}`;
        return resourceName.endsWith(expectedResourceSuffix);
    }
    return false;
};

/**
 * Handle SSM errors.
 *
 * @param {Error} error - The SSM error object.
 */
const handleSSMError = (error) => {
    console.error("SSM Error: ", error);
    throw error;
};