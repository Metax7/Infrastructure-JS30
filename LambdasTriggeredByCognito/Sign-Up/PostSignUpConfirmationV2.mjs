import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import { CognitoIdentityProviderClient, AdminUpdateUserAttributesCommand } from "@aws-sdk/client-cognito-identity-provider";
import { randomBytes, createCipheriv } from 'crypto';
import axios from 'axios';
import https from 'https';
import AWSXRay from 'aws-xray-sdk-core';

const client = new DynamoDBClient();
const docClient = AWSXRay.captureAWSv3Client(DynamoDBDocumentClient.from(client));
const cognitoClient = AWSXRay.captureAWSv3Client(new CognitoIdentityProviderClient({ region: process.env.AWS_DEFAULT_REGION }));
const TableName = 'USERS_LIKED_ITEMS_DEV';
const CIPHER_KEY_FULLNAME = "/sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";
const ENCODING_SCHEME = 'base64';
const INIT_VECTOR_SIZE = 16;  // 128 bits
const WITH_DECRYPTION = true;
const AWS_SESSION_TOKEN = process.env.AWS_SESSION_TOKEN;
const ENCRYPTION_ALG = 'aes-256-cbc';
const SSM_URL = "http://localhost:2773/systemsmanager/parameters/get";


// AWS Lambda function for adding a new user with a set of 1 elemnent - zero to DynamoDB
// Triggered by some event (e.g., PostConfirmation_ConfirmSignUp)

/**
 * Lambda function handler.
 *
 * @param {Object} event - The event object triggering the Lambda function.
 * @returns {Object} - The modified event object or an error message.
 */

export const handler = async (event) => {
    AWSXRay.captureHTTPsGlobal(https);
    AWSXRay.capturePromise();
    try {
        if (event.userName !== undefined) {
            const userId = event.userName.toString();
            const appName = 'JS30';
            const likedItems = new Set([0])
            const command = new PutCommand({
                TableName,
                Item: {
                    'UserId': userId,
                    'AppName': appName,
                    'LikedItems': likedItems
                }
            });

            await docClient.send(command);

            console.log(`Item created successfully in ${TableName}.`);

            if ("custom:google_refresh_token" in event.request.userAttributes) {
                const encryptedTextWithIV = await encrypt(event.request.userAttributes["custom:google_refresh_token"]);

                const input = {
                    UserPoolId: event.userPoolId,
                    Username: event.userName,
                    UserAttributes: [
                        {
                            Name: "custom:google_refresh_token",
                            Value: encryptedTextWithIV
                        }
                    ]
                };
                const command = new AdminUpdateUserAttributesCommand(input);
                await cognitoClient.send(command);
            }
            return event;
        } else {
            console.error('Error: userName is missing in the event.');
        }
    } catch (error) {
        if (error.name === 'DynamoDBError') {
            handleDynamoDBError(error);
        } else if (error.name === 'CognitoError') {
            handleCognitoError(error);
        } else {
            handleGenericError(error);
        }
    }
};

const retrieveSecuredParameter = async () => {
    try {
        const response = await axios.get(`${SSM_URL}?name=${CIPHER_KEY_FULLNAME}&withDecryption=${WITH_DECRYPTION.toString()}`, {
            headers: {
                'X-Aws-Parameters-Secrets-Token': AWS_SESSION_TOKEN
            }
        });

        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
};

const encrypt = async (text) => {
    
    try {
        const securedParameter = await retrieveSecuredParameter();
        if ('Value' in securedParameter.Parameter && 'Version' in securedParameter.Parameter) {
            const cipherKey = securedParameter.Parameter.Value;
            const keyVersion = securedParameter.Parameter.Version;
            const keyVersionEncoded = Buffer.from(keyVersion.toString()).toString(ENCODING_SCHEME);
            const key = Buffer.from(cipherKey, ENCODING_SCHEME);
            const iv = randomBytes(INIT_VECTOR_SIZE);
            const cipher = createCipheriv(ENCRYPTION_ALG, key, iv);
            let encrypted = cipher.update(text, 'utf-8', ENCODING_SCHEME);
            encrypted += cipher.final(ENCODING_SCHEME);
            const encryptedTextWithIV = keyVersionEncoded + iv.toString(ENCODING_SCHEME) + encrypted;
    
            console.log("Encryption succeeded! Key version: ", keyVersion);
    
            return encryptedTextWithIV;
            
        }

    } catch (error) {
        handleGenericError(error);
    }
};

const handleAxiosError = (error) => {
    console.error('Axios Error:', error.message);
    throw error;
};

const handleDynamoDBError = (error) => {
    console.error('DynamoDB Error:', error.message);
    throw error;
};

const handleCognitoError = (error) => {
    console.error('Cognito Identity Provider Error:', error.message);
    throw error;
};

const handleGenericError = (error) => {
    console.error('Unexpected Error:', error.message);
    throw error;
};

