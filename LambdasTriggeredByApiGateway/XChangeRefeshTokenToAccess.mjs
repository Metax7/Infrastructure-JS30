import axios from 'axios';
import https from 'https';
import { createDecipheriv } from 'crypto';
import AWSXRay from 'aws-xray-sdk-core';


const CIPHER_KEY_FULLNAME = "/sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";
const WITH_DECRYPTION = true;
const AWS_SESSION_TOKEN = process.env.AWS_SESSION_TOKEN;
const ENCODING_SCHEME = 'base64';
const IV_BASE64_SIZE = 24;
const KEY_VERSION_BASE64_SIZE = 4;
const ENCRYPTION_ALG = 'aes-256-cbc';
const GOOGLE_URL = "https://oauth2.googleapis.com/token";
const SSM_URL = "http://localhost:2773/systemsmanager/parameters/get";
const REVOKED_KEY_VERSIONS = process.env.REVOKED_KEY_VERSIONS;
const ENV = process.env.ENV;

export const handler = async (event) => {
    AWSXRay.captureHTTPsGlobal(https);
    AWSXRay.capturePromise();
    if (!('idpRefreshToken' in event)) {
        console.warn("No idp refresh token passed. Event: ", event);
        throw new Error("No idp refresh token passed.");
    }
    const encodedText = event.idpRefreshToken;
    // const decodedData = syncSubsegment("docode data", decodedData(encodedText));
    const decodedData = decodeData(encodedText);
    const [
        clientId,
        clientSecret,
        cipherkey

    ] = await Promise.all([
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_ID"),
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_SECRET"),
        retrieveSecuredParameter(`${CIPHER_KEY_FULLNAME}:${decodedData.keyVersion}`)

    ]);

    const plaintext = decrypt(decodedData.ciphertext, cipherkey.Parameter.Value, decodedData.iv);
    const freshData = await refreshTokens(clientId.Parameter.Value, clientSecret.Parameter.Value, plaintext);
    console.log("Encrypted with key version: ", decodedData.keyVersion);

    return freshData.access_token;
}

const decodeData = (encodedCiphertext) => {
    try {
        // Extract key version, IV, and encrypted text from the input
        const keyVersionEncoded = encodedCiphertext.slice(0, KEY_VERSION_BASE64_SIZE);
        const keyVersion = Number(Buffer.from(keyVersionEncoded, ENCODING_SCHEME).toString());
        if (keyVersion < 1 || keyVersion > 100) {
            throw new Error(`Invalid key version: ${keyVersion} . Allowed SSM parameter versions: 1-100`);
        }

        if (REVOKED_KEY_VERSIONS.includes(keyVersion)) {
            throw new Error(`Invalid key version: ${keyVersion} . This cipherkey is revoked.`);
        }
        const iv = Buffer.from(encodedCiphertext.slice(KEY_VERSION_BASE64_SIZE, KEY_VERSION_BASE64_SIZE + IV_BASE64_SIZE), ENCODING_SCHEME);
        const ciphertext = encodedCiphertext.slice(KEY_VERSION_BASE64_SIZE + IV_BASE64_SIZE);
        return {
            keyVersion: keyVersion,
            iv: iv,
            ciphertext: ciphertext
        };
    } catch (error) {
        handleGenericError(error);
    }
};

const decrypt = (ciphertext, cipherkey, iv) => {
    const key = Buffer.from(cipherkey, ENCODING_SCHEME);
    const decipher = createDecipheriv(ENCRYPTION_ALG, key, iv);
    let decrypted = decipher.update(ciphertext, ENCODING_SCHEME, 'utf-8');
    decrypted += decipher.final('utf-8');
    return decrypted;
}

const retrieveSecuredParameter = async (queryParameter) => {
    try {
        const response = await axios.get(`${SSM_URL}?name=${queryParameter}&withDecryption=${WITH_DECRYPTION.toString()}`, {
            headers: {
                'X-Aws-Parameters-Secrets-Token': AWS_SESSION_TOKEN
            }
        });

        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
};

const refreshTokens = async (clientId, clientSecret, refreshToken) => {
    const body = {};
    body.grant_type = 'refresh_token';
    body.client_id = clientId;
    body.refresh_token = refreshToken;
    body.clientSecret = clientSecret;
    try {
        const response = await axios.post(GOOGLE_URL, body, { 'Content-Type': 'application/x-www-form-urlencoded' });
        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
};

const handleAxiosError = (error) => {
    console.error('Axios Error:', error.message);
    throw new Error('Axios Error: ' + error.message);
};

const handleGenericError = (error) => {
    console.error('Unexpected Error:', error.message);
    throw new Error('Unexpected Error: ' + error.message);
};

const syncSubsegment = (name, fn) => {
    const subsegment = AWSXRay.getSegment().addNewSubsegment(name);
    try {
        return fn();
      } catch (e) {
        subsegment.addError(e);
        throw e;
      } finally {
        subsegment.close();
      }
}

const asyncSubsegment = async (name, fn) => {
    const subsegment = AWSXRay.getSegment().addNewSubsegment(name);
    try {
      return await fn();
    } catch (e) {
      subsegment.addError(e);
      throw e;
    } finally {
      subsegment.close();
    }
  }
