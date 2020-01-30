#!/bin/bash

[ -z `which aws-okta` ] && echo "Please run 'brew install aws-okta' in order to operate this script" && exit 1

aws_account_profile=$1

aws-okta exec $aws_account_profile -- env | grep "AWS_" > secrets.env
echo "Where are you going to create the secret? branch|staging|production"

read secret_location
case "$secret_location" in
   branch)
     ACCOUNT_ALIAS=victoria-playground
   ;;
   staging)
     ACCOUNT_ALIAS=victoria-staging
   ;;
   production)
     ACCOUNT_ALIAS=victoria-production
   ;;
   *)
      echo "Invalid answer, please choose between branch, staging and production"
      exit 1
   ;;
esac

KMS_KEY_ID=`aws-okta exec $aws_account_profile -- aws kms list-aliases | grep -h1 $ACCOUNT_ALIAS | grep TargetKeyId | awk -F '\"' '{print $4}'`
echo KMS_KEY_ID=$KMS_KEY_ID >> secrets.env

echo "Credentials correctly set, now you are able to create secrets"
