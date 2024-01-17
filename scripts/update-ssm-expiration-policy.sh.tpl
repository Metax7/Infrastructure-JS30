#!/bin/bash

aws ssm put-parameter \
   --profile ${PROFILE} \
   --overwrite \
   --name " ${NAME}" \
   --value ${VALUE} \
   --policies ${POLICIES}


# pay attention that we have a space beofre name variable. This is WINDDOS+GITBASH bug. See down below
# https://stackoverflow.com/questions/52921242/aws-ssm-put-parameter-validation-exception