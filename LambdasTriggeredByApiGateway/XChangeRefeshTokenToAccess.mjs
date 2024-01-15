export const handler = async (event) => {
    // 0. async get ClientID and ClientSecret from SSM
    // 1. extract timestamp
    // 2. decode timestamp
    // 3. async:  get from DynamoDB cipherkey reference
    // 4. async: get Cipherkey from SSM by passing cipherkey reference
    // 5. extract IV 
    // 6. decode IV
    // 7. decrypt ciphertext with cipherkey from SSM
    // 8. async send POST request to IdP with refresh_token
    // 9. return access_token from the request
    
}