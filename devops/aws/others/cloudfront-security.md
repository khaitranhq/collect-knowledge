# CloudFront Security

## Signed URL / Signed Cookie

![](/home/lewis/LinuxWorkspaces/Personal/collect-knowledge/assets/2025-04-13-12-47-23.png)

## Field in Payload Level Encryption

![](/home/lewis/LinuxWorkspaces/Personal/collect-knowledge/assets/2025-04-13-12-48-38.png)

## CloudFront with S3 SSE-KMS

### OAC

- OAC supports SSE-KMS natively (as requests are signed with Sigv4)
- Add a statement to the KMS Key Policy to authorize the OAC

## OAI

- OAI doesn’t support SSE-KMS natively (only SSE-S3)
- Use Lambda@Edge to sign requests from CloudFront to S3
- Make sure to disable OAI for this to work

![](/home/lewis/LinuxWorkspaces/Personal/collect-knowledge/assets/2025-04-13-12-50-13.png)

## Authorization Header

> **Note:** Not supported for S3 Origins

![](/home/lewis/LinuxWorkspaces/Personal/collect-knowledge/assets/2025-04-13-12-50-43.png)

## With Cognito

![](/home/lewis/LinuxWorkspaces/Personal/collect-knowledge/assets/2025-04-13-13-02-40.png)
