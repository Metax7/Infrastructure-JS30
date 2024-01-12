import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient, } from "@aws-sdk/lib-dynamodb";


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

const TableName = 'USERS_LIKED_ITEMS_DEV';

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
            return event;
        } else {
            console.error('Error: userName is missing in the event.');
        }
    } catch (error) {
        console.error('Error in DynamoDB operation:', error.message);
        throw error;
    }
};