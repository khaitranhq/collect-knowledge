# IAM Policy for AWS S3 Sync command

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME",
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ],
      "Sid": "Stmt1464826210000",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ]
    }
  ]
}
```
