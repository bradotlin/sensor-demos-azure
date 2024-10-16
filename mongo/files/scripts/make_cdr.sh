#!/bin/bash
set -x

export HOME=/root
export LC_ALL=C

if [[ -z "${COMPROMISED_USER_NAME}" ]]; then
  COMPROMISED_USER_NAME="lior-admin"
fi

#cer-correlation-id-43
aws iam list-access-keys &>/dev/null
aws iam list-groups &>/dev/null
aws iam list-roles &>/dev/null
aws iam list-users &>/dev/null
aws iam list-user-policies --user-name $COMPROMISED_USER_NAME  &>/dev/null
aws iam list-attached-user-policies --user-name $COMPROMISED_USER_NAME &>/dev/null
aws iam get-account-authorization-details &>/dev/null

#cer-correlation-id-44
aws ec2 describe-instances --region us-east-1 &>/dev/null
aws ec2 describe-instances --region us-east-2 &>/dev/null
aws ec2 describe-instances --region us-west-1 &>/dev/null
aws ec2 describe-instances --region us-west-2 &>/dev/null

#run openssl to create VIR issues
openssl genrsa -out yourdomain.key 2048
