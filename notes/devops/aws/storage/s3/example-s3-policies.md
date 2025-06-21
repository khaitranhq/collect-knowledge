# Example S3 Policies

## Force HTTPS In Flight

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
```

## Restrict Public IP Address

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["11.11.11.11/24"]
        }
      }
    }
  ]
}
```

## Restrict by User ID

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "StringNotLike": {
          "aws:userId": ["RoleIDexample:*", "UserIDexample", "123456789012"]
        }
      }
    }
  ]
}
```
