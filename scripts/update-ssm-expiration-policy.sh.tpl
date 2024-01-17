#!/bin/bash

SUCCESS_MSG="NOTFICATION POLICY HAS BEEN UPATED"

setNotificationPolicy()
{
   aws ssm put-parameter \
      --profile ${PROFILE} \
      --overwrite \
      --name " ${NAME}" \
      --value ${VALUE} \
      --policies ${POLICIES}
}

if setNotificationPolicy ; then
    echo "\033[32m${SUCCESS_MSG}\033[m"
fi


# pay attention that we have a space beofre name variable. This is WINDDOS+GITBASH bug. See down below
# https://stackoverflow.com/questions/52921242/aws-ssm-put-parameter-validation-exception