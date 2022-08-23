#!/bin/bash

[ -z `which jq` ] && echo "Please run 'brew install jq' in order to operate this script" && exit 1

if ! [[ $(env | grep "AWS_" | grep -E "ACCESS_KEY|SESSION_TOKEN") ]]; then
  echo "Please set required AWS environment variables"
  echo "[AWS SSO] Login to AWS SSO portal and copy/paste environment variables"
  echo "[DEPRECATED aws-okta] Run 'aws-okta exec <aws_account_profile> -- \$SHELL'"
  exit 1
fi

env | grep "AWS_" > secrets.env
echo "AWS Account Alias for the secret? b, victoria-playground | s, victoria-staging | p, victoria-production | d, detect"

read secret_location
case "$secret_location" in
  b|branch)
    ACCOUNT_ALIAS=victoria-playground
    AWS_REGION=us-east-1
  ;;
  s|staging)
    ACCOUNT_ALIAS=victoria-staging
    AWS_REGION=us-east-1
  ;;
  p|production)
    ACCOUNT_ALIAS=victoria-production
    AWS_REGION=us-east-1
  ;;
  d|detect)
    ACCOUNT_ALIAS=`aws iam list-account-aliases --query 'AccountAliases[0]' --output text`
  ;;
   *)
      echo "Invalid answer, please choose between: b, branch | s, staging | p, production | d, detect"
      exit 1
  ;;
esac

KMS_KEY_ID=`aws kms list-aliases --region $AWS_REGION --output json | jq -r --arg ACCOUNT_ALIAS $ACCOUNT_ALIAS '.Aliases[] | select(.AliasName|endswith($ACCOUNT_ALIAS)) | .TargetKeyId'`

echo KMS_KEY_ID=$KMS_KEY_ID >> secrets.env
echo AWS_DEFAULT_REGION=$AWS_REGION >> secrets.env

echo "Credentials set in ./secrets.env. victoriaTreasure ready"
echo "Credentials will expire after an hour"
