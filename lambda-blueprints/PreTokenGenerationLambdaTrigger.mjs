console.log("Pre Token Generation Lambda triggered!")

export const handler = function(event, context) {
    console.log(event)
    event.response = {
      "claimsAndScopeOverrideDetails": {
        "idTokenGeneration": {
          "claimsToAddOrOverride": {
            "family_name": "Doe"
      },
          "claimsToSuppress": [
            "email",
            "phone_number"
      ]
        },
        "accessTokenGeneration": {
          "scopesToAdd": [
            "openid",
            "email",
            "solar-system-data/asteroids.add"
          ],
          "scopesToSuppress": [
            "phone_number",
            "aws.cognito.signin.user.admin"
          ]
        },
        "groupOverrideDetails": {
          "groupsToOverride": [
            "new-group-A",
            "new-group-B",
            "new-group-C"
          ],
          "iamRolesToOverride": [
            "arn:aws:iam::123456789012:role/new_roleA",
            "arn:aws:iam::123456789012:role/new_roleB",
            "arn:aws:iam::123456789012:role/new_roleC"
          ],
          "preferredRole": "arn:aws:iam::123456789012:role/new_role",
        }
      }
    };
    // Return to Amazon Cognito
    context.done(null, event);
  };