#!/bin/bash

aws ssm put-parameter \
   --no-overwrite \
   --name /sandbox/metax7/js30/dev/JS30_REFRESH_TOKEN_CIPHER_KEY_CURRENT \
   --value none \
   --policies "[{\"Type\":\"Expiration\",\"Version\":\"1.0\",\"Attributes\": {\"Timestamp\":\"2024-01-16T23:07:01Z\"}}]" 