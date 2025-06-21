# Regain Access to Locked S3 Buckets

## Problem

If you've accidentally configured your S3 bucket policy to deny access to everyone using a statement like:

```json
{
  "Effect": "Deny",
  "Action": "s3:*",
  "Principal": "*",
  "Resource": ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
}
```

This effectively locks everyone out of the bucket, including IAM users with administrative permissions.

## Solution

1. Sign in to the AWS Management Console using the **AWS account root user**
2. Navigate to the S3 service
3. Locate and select the locked bucket
4. Go to the "Permissions" tab
5. Delete the restrictive bucket policy

## Why This Works

Deny statements in IAM policies do not affect the AWS account root user, which always maintains full access to all resources in the account.

## Prevention Tips

- Always test bucket policies with limited scope before applying broadly
- Include a condition in deny policies to exclude administrative roles/users
- Set up alerts for policy changes to critical buckets
