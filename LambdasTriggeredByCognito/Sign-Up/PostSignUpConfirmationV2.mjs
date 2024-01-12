import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient, } from "@aws-sdk/lib-dynamodb";
import { CognitoIdentityProviderClient, AdminUpdateUserAttributesCommand } from "@aws-sdk/client-cognito-identity-provider";
import { randomBytes, createCipheriv } from 'crypto';


// AWS Lambda function for adding a new user with a set of 1 elemnent - zero to DynamoDB
// Triggered by some event (e.g., PostConfirmation_ConfirmSignUp)

/**
 * Lambda function handler.
 *
 * @param {Object} event - The event object triggering the Lambda function.
 * @returns {Object} - The modified event object or an error message.
 */

const client = new DynamoDBClient();
const docClient = DynamoDBDocumentClient.from(client);
const cognitoClient = new CognitoIdentityProviderClient({ region: "us-west-1" });
const TableName = 'USERS_LIKED_ITEMS_DEV';

const encrypt = (text) => {
    const algorithm = 'aes-256-cbc';
    let key = randomBytes(32); // 256 bits
    const iv = randomBytes(16); // 128 bits
    const cipher = createCipheriv(algorithm, key, iv);
    let encrypted = cipher.update(text, 'utf-8', 'base64');
    encrypted += cipher.final('base64');
    const encryptedTextWithIV = iv.toString('base64') + encrypted;
    key = key.toString('base64')

    console.log("Encryption succeeded! Encryption Key:", key);

    return {
        key: key,
        encryptedTextWithIV: encryptedTextWithIV
    };
};

export const handler = async (event) => {

    try {
        if (event.userName !== undefined) {
            const userId = event.userName.toString();
            const appName = 'JS30';
// The most important reminder on using DynamoDBDocumentClient is that it marshalls JS types to 
// those of DynamoDB, which is why we mustn't use "NS, SS" etc in anyway. Check the documentation
// of the lib to see the mapping.
            const likedItems = new Set([0])
            const command = new PutCommand({
                TableName,
                Item: {
                    'UserId': userId ,
                    'AppName': appName ,
                    'LikedItems': likedItems
                }
            });

            await docClient.send(command);

            console.log(`Item created successfully in ${TableName}.`);


            if ("custom:google_refresh_token" in event.request.userAttributes) {
                const encryptedData = encrypt(event.request.userAttributes["custom:google_refresh_token"]);
           
                const input = { 
                  UserPoolId: event.userPoolId, 
                  Username: event.userName,
                  UserAttributes: [ 
                    { 
                      Name: "custom:google_refresh_token", 
                      Value: encryptedData.encryptedTextWithIV
                    }]
                };
                const command = new AdminUpdateUserAttributesCommand(input);
                await cognitoClient.send(command);
                // Optionally, store the key and IV for future decryption
                console.log("Encryption Key:", encryptedData.key);   
            }
            return event;
        } else {
            console.error('Error: userName is missing in the event.');
        }
    } catch (error) {
        console.error('Error in DynamoDB operation:', error.message);
        throw error;
    }
};