#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -n name -p policies"
   echo -e "\t-n name of AWS SSM parameter"
   echo -e "\t-p array of expiration policies"
   exit 1 # Exit script after printing help
}

while getopts "n:p:" opt
do
   case "$opt" in
      n ) NAME="$OPTARG" ;;
      p ) POLICIES="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$NAME" ] || [ -z "$POLICIES" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

aws ssm put-parameter \
   --no-overwrite \
   --name "${NAME}" \
   --value none \
   --policies "${POLICIES}" > /dev/null 