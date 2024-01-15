import { randomBytes } from 'crypto';
import axios from 'axios';
import { SSMClient, PutParameterCommand } from "@aws-sdk/client-ssm";

const ENCODING_SCHEME = 'base64';
const KEY_SIZE = 32; // 256 bits
const WITH_DECRYPTION = true;
const CIPHER_KEY_FULLNAME = "sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";
const CURRENT = "_CURRENT";
const ssmClient = new SSMClient({ region: "us-west-1" });

/**
 * Lambda function handler for key rotation.
 *
 * @param {Object} event - The event object triggering the Lambda function.
 * @param {Object} context - The context object containing information about the execution environment.
 */
export const handler = async (event, context) => {
    // 1. Retrieve expired and new cipher keys concurrently
    const [
        expiredCipherkeyResult,
        newKeyMaterial
    ] = await Promise.all([
        getExpiredCipherkey(),
        generateCipherkey()
    ]);

    // 2. Update current cipher key
    updateCurrentCipherkey(newKeyMaterial);

    // 3. Save expired cipher key with its version
    saveExpiredCipherkey(expiredCipherkeyResult.expiredKey, expiredCipherkeyResult.expiredVersion, context);
};

/**
 * Save expired cipher key with its version as a part of its name.
 *
 * @param {string} expiredKey - The expired cipher key.
 * @param {string} expiredVersion - The version of the expired cipher key.
 * @param {Object} context - The context object containing information about the execution environment.
 */
const saveExpiredCipherkey = async (expiredKey, expiredVersion, context) => {
    const paramName = CIPHER_KEY_FULLNAME + `_${expiredVersion}`;
    const currentDate = new Date();
    const futureDate = new Date(currentDate);
    futureDate.setFullYear(currentDate.getFullYear() + 5);
    const expiresAt = futureDate.toISOString().split('.')[0] + 'Z';

    const policies = [{
        "Type": "Expiration",
        "Version": "1.0",
        "Attributes": {
            "Timestamp": expiresAt
        }
    }];

    const input = {
        Name: paramName,
        Description: "Expired Cipherkey to execute encrypt/decrypt operations in DEV environment",
        Value: expiredKey,
        Type: "SecureString",
        Overwrite: false,
        Tags: [
            {
                Key: "CreatedBy",
                Value: `${context.functionName}:${context.functionVersion}`,
            },
            {
                Key: "InvokedBy",
                Value: `${context.invokedFunctionArn}`,
            },
        ],
        Tier: "Standard",
        Policies: policies,
    };

    const command = new PutParameterCommand(input);
    await ssmClient.send(command);
};

/**
 * Update the current cipher key.
 *
 * @param {string} newKey - The new cipher key material.
 */
const updateCurrentCipherkey = async (newKey) => {
    const paramName = `${CIPHER_KEY_FULLNAME}${CURRENT}`;
    const input = {
        Name: paramName,
        Value: newKey,
        Overwrite: true,
    };

    const command = new PutParameterCommand(input);
    await ssmClient.send(command);
};

/**
 * Retrieve expired parameter with decryption.
 *
 * @returns {Promise<{ expiredVersion: string, expiredKey: string }>} - A Promise that resolves to an object containing the expired version and key.
 */
const getExpiredCipherkey = async () => {
    try {
        const expiredkeyParam = await retrieveSecuredParameter();

        if ('Value' in expiredkeyParam.Parameter && 'Version' in expiredkeyParam.Parameter) {
            return {
                expiredVersion: expiredkeyParam.Parameter.Version,
                expiredKey: expiredkeyParam.Parameter.Value
            };
        } else {
            throw new Error("Key Material or Version is not present.");
        }
    } catch (error) {
        handleSSMError(error);
    }
};

/**
 * Generate a new cipher key.
 *
 * @returns {Promise<string>} - A Promise that resolves to the new cipher key material.
 */
const generateCipherkey = async () => {
    const cipherkey = randomBytes(KEY_SIZE);
    return cipherkey.toString(ENCODING_SCHEME);
};

/**
 * Retrieve secured parameter from the external service.
 *
 * @returns {Promise<Object>} - A Promise that resolves to the secured parameter object.
 */
const retrieveSecuredParameter = async () => {
    try {
        const response = await axios.get(`http://localhost:2773/systemsmanager/parameters
        /get?name=/${CIPHER_KEY_FULLNAME}${CURRENT}&withDecryption=${WITH_DECRYPTION.toString()}`, {
            headers: {
                'X-Aws-Parameters-Secrets-Token': AWS_SESSION_TOKEN
            }
        });

        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
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

/**
 * Handle Axios errors.
 *
 * @param {Error} error - The Axios error object.
 */
const handleAxiosError = (error) => {
    console.error('Axios Error:', error);
    throw error;
};
