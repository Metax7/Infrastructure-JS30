import axios from 'axios';
import createDecipheriv  from 'crypto';

const CIPHER_KEY_FULLNAME = "/sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";
const ENCODING_SCHEME = 'base64';
const IV_BASE64_SIZE = 24;
const KEY_VERSION_BASE64_SIZE = 4;
const ENCRYPTION_ALG = 'aes-256-cbc';
const GOOGLE_URL = "https://oauth2.googleapis.com/token";
const SSM_URL = "http://localhost:2773/systemsmanager/parameters/get";

export const handler = async (event) => {
    if (!('idpRefreshToken' in event)) {
        console.warn("No idp refresh token passed. Event: ", event)
        throw new Error("No idp refresh token passed.")
    }
       
    const encodedText = event.idpRefreshToken

    const decodedData = decodeData(encodedText)
    const [
        clientId,
        clientSecret,
        cipherkey
    ] = await Promise.all([
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_ID"),
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_SECRET"),
        retrieveSecuredParameter(`${CIPHER_KEY_FULLNAME}:${decodedData.keyVersion}`)

    ]);

    const plaintext = decrypt(decodedData.ciphertext, cipherkey, decodedData.iv);
    const freshData = await refreshTokens(clientId,clientSecret,plaintext);
    console.log(freshData);

    return freshData.access_token;
}

const decodeData = async (encryptedTextWithIVandVersion) => {
    try {
        // Extract key version, IV, and encrypted text from the input
        const keyVersionEncoded = encryptedTextWithIVandVersion.slice(0, KEY_VERSION_BASE64_SIZE);
        const keyVersion = Number(Buffer.from(keyVersionEncoded, ENCODING_SCHEME).toString());
        if (keyVersion<1 || keyVersion > 100) throw new Error(`Invalid key version: ${keyVersion} . Allowed SSM parameter versions: 1-100`)
        const iv = Buffer.from(encryptedTextWithIVandVersion.slice(KEY_VERSION_BASE64_SIZE, KEY_VERSION_BASE64_SIZE + IV_BASE64_SIZE), ENCODING_SCHEME);
        const ciphertext = encryptedTextWithIVandVersion.slice(KEY_VERSION_BASE64_SIZE + IV_BASE64_SIZE);
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
    const decipher = createDecipheriv(ENCRYPTION_ALG, cipherkey, iv);
    let decrypted = decipher.update(ciphertext, ENCODING_SCHEME, 'utf-8');
    decrypted += decipher.final('utf-8');
    console.log("Decryption succeeded! Key version: ", keyVersion);
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
}

const refreshTokens = async (clientId, clientSecret,refreshToken) => {
    const body = {};
    body.grant_type = 'refresh_token';
    body.client_id = clientId;
    body.refresh_token = refreshToken;
    body.clientSecret = clientSecret;
    try {
        const response = await axios.post(GOOGLE_URL,body,{ 'Content-Type': 'application/x-www-form-urlencoded' })
        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
}

const handleAxiosError = (error) => {
    console.error('Axios Error:', error.message);
    throw new Error('Axios Error: ' + error.message);
};

const handleGenericError = (error) => {
    console.error('Unexpected Error:', error.message);
    throw new Error('Unexpected Error: ' + error.message);
};
