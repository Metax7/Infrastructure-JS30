#!/bin/bash

OPTIONS="n:v:a:p";

helpFunction()
{
   echo ""
   echo "Usage: $0 -n name -v value -p policies -a aws-profile"
   echo -e "\t-n name of AWS SSM parameter"
   echo -e "\t-v value of AWS SSM parameter"
   echo -e "\t-p array of expiration policies"
   echo -e "\t-a aws profile"
   exit 1 # Exit script after printing help
}

error()
{
  echo "$0 failed to parse parameters";
  helpFunction
}

while getopts $OPTIONS opt;
do
   case "$opt" in
      n ) NAME="$OPTARG" ;;
      v ) VALUE="$OPTARG" ;;
      a ) PROFILE="$OPTARG" ;;
      p ) POLICIES_ARRAY=$(echo "${POLICIES}" | jq -c .) ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


# Print helpFunction in case parameters are empty
if [ -z "$NAME" ] || [ -z "$VALUE" ] || [ -z "$PROFILE" ] || [ -z "$POLICIES_ARRAY" ]
then
   echo "Some or all of the parameters are empty";
   echo "Passed parameters:";
   echo "NAME: ${NAME}";
   echo "VALUE: ${VALUE}";
   echo "PROFILE: ${PROFILE}";
   echo "POLICIES: ${POLICIES_ARRAY}";
   helpFunction
fi



# Begin script in case all parameters are correct

aws ssm put-parameter \
   --overwrite \
   --name "${NAME}" \
   --value "${VALUE}" \
   --policies "${POLICIES_ARRAY}" \
   --profile "${PROFILE}"
