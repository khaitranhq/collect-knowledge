# Data Export Tool

This tool exports data from Langfuse PostgreSQL RDS tables (`events` and `observations`) to an Amazon S3 bucket.

## Prerequisites

- AWS CLI installed and configured
- PostgreSQL client tools installed
- Appropriate IAM permissions to create S3 buckets, IAM roles, and policies
- Access to the Langfuse RDS instance

## Setup Steps

### 1. Create S3 Bucket

```bash
# Read RDS identifier and S3 bucket name
read -p "Enter RDS identifier: " RDS_IDENTIFIER
read -p "Enter S3 bucket name: " S3_BUCKET_NAME
read -p "Enter AWS Region: " AWS_REGION

# Create S3 bucket
aws s3api create-bucket \
    --bucket $S3_BUCKET_NAME \
    --create-bucket-configuration LocationConstraint=$AWS_REGION
```

### 2. Create IAM Policy for S3 Export

```bash
# Create IAM policy for S3 export
aws iam create-policy \
    --policy-name langfuse-s3-export-policy \
    --policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "s3export",
                "Action": [
                    "s3:PutObject*",
                    "s3:ListBucket",
                    "s3:GetObject*",
                    "s3:DeleteObject*",
                    "s3:GetBucketLocation",
                    "s3:AbortMultipartUpload"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::'$S3_BUCKET_NAME'/*",
                    "arn:aws:s3:::'$S3_BUCKET_NAME'"
                ]
            }
        ]
    }'

# Store the policy ARN
POLICY_ARN=$(aws iam create-policy --query 'Policy.Arn' --output text)
echo "Policy ARN: $POLICY_ARN"
```

### 3. Create IAM Role for RDS

```bash
# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

# Create IAM role
aws iam create-role \
    --role-name langfuse-s3-export-role \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "rds.amazonaws.com"
                },
                "Action": "sts:AssumeRole",
                "Condition": {
                    "StringEquals": {
                        "aws:SourceAccount": "'$AWS_ACCOUNT_ID'",
                        "aws:SourceArn": "arn:aws:rds:ap-southeast-1:'$AWS_ACCOUNT_ID':db:'$RDS_IDENTIFIER'"
                    }
                }
            }
        ]
    }'

# Attach policy to role
aws iam attach-role-policy \
    --policy-arn $POLICY_ARN \
    --role-name langfuse-s3-export-role

# Get role ARN
ROLE_ARN=$(aws iam get-role --role-name langfuse-s3-export-role --query 'Role.Arn' --output text)
echo "Role ARN: $ROLE_ARN"
```

### 4. Associate IAM Role with RDS Instance

```bash
# Add role to RDS instance
aws rds add-role-to-db-instance \
    --db-instance-identifier $RDS_IDENTIFIER \
    --feature-name s3Export \
    --role-arn $ROLE_ARN
```

### 5. Install PostgreSQL aws_s3 Extension

Connect to your PostgreSQL database and run:

```sql
CREATE EXTENSION aws_s3 CASCADE;
```

### 6. Export Data to S3

Connect to your PostgreSQL database and run the following commands to export data:

```sql
-- Export events table
SELECT aws_s3.query_export_to_s3(
    'SELECT * FROM public.events',
    aws_commons.create_s3_uri(
        '$S3_BUCKET_NAME',
        'data.csv',
        'ap-southeast-1'
    ),
    options :='format csv, header true'
);

```

## Automation Script

For convenience, a shell script is provided to automate these steps. Run:

```bash
./export_langfuse_data.sh
```

## Troubleshooting

- If you encounter permission issues, verify that the IAM role has been properly attached to the RDS instance
- Check that the aws_s3 extension is installed in the PostgreSQL database
- Ensure the S3 bucket exists and is accessible from the RDS instance

## Cleanup

To clean up resources after export:

```bash
# Remove role from RDS instance
aws rds remove-role-from-db-instance \
    --db-instance-identifier $RDS_IDENTIFIER \
    --feature-name s3Export \
    --role-arn $ROLE_ARN

# Detach policy from role
aws iam detach-role-policy \
    --role-name langfuse-s3-export-role \
    --policy-arn $POLICY_ARN

# Delete role
aws iam delete-role \
    --role-name langfuse-s3-export-role

# Delete policy
aws iam delete-policy \
    --policy-arn $POLICY_ARN

# Empty and delete S3 bucket
aws s3 rm s3://$S3_BUCKET_NAME --recursive
aws s3api delete-bucket --bucket $S3_BUCKET_NAME
```
