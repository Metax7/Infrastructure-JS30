import axios from 'axios';

const CIPHER_KEY_FULLNAME = "/sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY";

export const handler = async (event) => {

    // 1) validate event
    // 2) extract version and decode
    // 3) extract IV and decode


    const version = Number(cipherkeyVersion);
    const [
        clientId,
        clientSecret,
        cipherkey
    ] = await Promise.all([
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_ID"),
        retrieveSecuredParameter("/sandbox/metax7/js30/dev/JS30_GOOGLE_CLIENT_SECRET"),
        retrieveSecuredParameter(`${CIPHER_KEY_FULLNAME}:${version}`)

    ]);


    // 7. decrypt ciphertext with cipherkey from SSM
    // 8. async send POST request to IdP with refresh_token
    // 9. return access_token from the request

}

const retrieveSecuredParameter = async (queryParameter) => {
    try {
        const response = await axios.get(`http://localhost:2773/systemsmanager/parameters/get?name=${queryParameter}&withDecryption=${WITH_DECRYPTION.toString()}`, {
            headers: {
                'X-Aws-Parameters-Secrets-Token': AWS_SESSION_TOKEN
            }
        });

        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
}

const handleAxiosError = (error) => {
    console.error('Axios Error:', error.message);
    throw error;
};