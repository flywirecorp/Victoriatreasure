#!/bin/bash

[ -z `which aws-okta` ] && echo "Please run 'brew install aws-okta' in order to operate this script" && exit 1

aws_account_profile=$1

aws-okta exec $aws_account_profile -- env | grep "AWS_" > secrets.env
ACCOUNT_ALIAS=`aws-okta exec $aws_account_profile -- aws iam list-account-aliases --query 'AccountAliases[0]' --output text`
KMS_KEY_ID=`aws-okta exec $aws_account_profile -- aws kms list-aliases | grep -h1 $ACCOUNT_ALIAS | grep TargetKeyId | awk -F '\"' '{print $4}'`
echo KMS_KEY_ID=$KMS_KEY_ID >> secrets.env
