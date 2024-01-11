import { randomBytes, createCipheriv } from 'crypto';

console.log("Pre SignUp Lambda has been triggered by Cognito User Pool");

const encrypt = (text) => {
    const algorithm = 'aes-256-cbc';
    const key = randomBytes(32); // 256 bits
    const iv = randomBytes(16); // 128 bits

    const cipher = createCipheriv(algorithm, key, iv);
    console.log("cipher :", cipher)
    let encrypted = cipher.update(text, 'utf-8', 'base64');
    encrypted += cipher.final('base64');

    const encryptedTextWithIV = iv.toString('base64') + encrypted;

    return {
        key: key.toString('base64'),
        encryptedTextWithIV: encryptedTextWithIV
    };
};

const handler = async (event, context) => {
    try {
        console.log("event:", event);
        console.log("context:", context);

        event.response.autoConfirmUser = true;

        if ("email" in event.request.userAttributes) {
            event.response.autoVerifyEmail = true;
        }

        if ("phone_number" in event.request.userAttributes) {
            event.response.autoVerifyPhone = true;
        }

        if ("custom:google_refresh_token" in event.request.userAttributes) {

            const encryptedData = encrypt(event.request.userAttributes["custom:google_refresh_token"]);
            event.request.userAttributes["custom:google_refresh_token"] = encryptedData.encryptedText;

            // Optionally, store the key and IV for future decryption
            console.log("Encryption Key:", encryptedData.key);
        }

        console.log("event before return:", event);
        return event;
    } catch (error) {
        console.error("Error:", error);
        throw error;
    }
};
const testEvent = {
    version: '1',
    region: 'us-west-1',
    userPoolId: 'us-west-1_DMqCcn38p',
    userName: 'google_102393576698312953832',
    callerContext: {
      awsSdkVersion: 'aws-sdk-unknown-unknown',
      clientId: '1rq65aa262uk8bmvbunb8fqg31'
    },
    triggerSource: 'PreSignUp_ExternalProvider',
    request: {
      userAttributes: {
        email_verified: 'true',
        'cognito:email_alias': '',
        'custom:google_refresh_token': '1//06AuKAECR1woLCgYIARAAGAYSNwF-L9IrLqO8AU1-a8VoG7GvuFTP_trMCt5ibtUvWKeHf0Ssl-vyuQiyE9fk5h0SQHc8u9iAY-c',
        'cognito:phone_number_alias': '',
        given_name: 'Dmitri',
        family_name: 'Konnov',
        email: 'dmitri.v.konnov@gmail.com',
        picture: 'https://lh3.googleusercontent.com/a/ACg8ocJ4rsrAHQjCrTotXS8G1SOjjwRRiL9QVCfKDX0rVW37DA=s96-c'
      },
      validationData: {}
    },
    response: {
      autoConfirmUser: true,
      autoVerifyEmail: true,
      autoVerifyPhone: false
    }
  }
handler(testEvent)

export { handler };
