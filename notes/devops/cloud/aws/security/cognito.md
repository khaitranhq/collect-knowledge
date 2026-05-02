# AWS Cognito

Amazon Cognito provides authentication, authorization, and user management for web and mobile applications. There are two main components: User Pools and Identity Pools.

## Cognito User Pools (CUP)

![Cognito User Pools Architecture](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-49-39.png)

### Core Features

- Serverless user directory for web & mobile applications
- Authentication capabilities:
  - Username/email and password authentication
  - Self-service password reset
  - Email & phone number verification
  - Multi-factor authentication (MFA)
  - Federated identity support (Facebook, Google, SAML, etc.)
  - Compromised credential protection
- Returns JSON Web Tokens (JWT) after successful authentication
- Integrates with API Gateway and Application Load Balancer

### Lambda Triggers

CUP can invoke Lambda functions synchronously on various events:

| Event Category            | Trigger Point        | Description                                           |
| ------------------------- | -------------------- | ----------------------------------------------------- |
| **Authentication Events** | Pre Authentication   | Custom validation to accept or deny sign-in requests  |
|                           | Post Authentication  | Event logging for custom analytics                    |
|                           | Pre Token Generation | Augment or suppress token claims                      |
| **Sign-Up**               | Pre Sign-up          | Custom validation to accept or deny sign-up requests  |
|                           | Post Confirmation    | Custom welcome messages or event logging              |
|                           | Migrate User         | Migrate users from existing directories to user pools |
| **Messages**              | Custom Message       | Advanced customization and localization of messages   |
| **Token Creation**        | Pre Token Generation | Add or remove attributes in ID tokens                 |

### Hosted UI

- Provides ready-to-use authentication flows for sign-up and sign-in
- Foundation for integration with:
  - Social logins
  - OIDC (OpenID Connect)
  - SAML (Security Assertion Markup Language)
- Customization options:
  - Custom logo
  - Custom CSS styling

## Cognito Identity Pools (Federated Identities)

![Cognito Identity Pools Architecture](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-53-08.png)

### Core Features

- Provides temporary AWS credentials to access AWS services directly or via API Gateway
- Identity sources can include:
  - Public providers (Amazon, Facebook, Google, Apple) (Not recommend - use with Cognito instead)
  - Users from Cognito User Pools
  - OpenID Connect and SAML identity providers
  - Developer authenticated identities (custom login servers)
- Supports unauthenticated (guest) access
- IAM policies are defined in Cognito and can be customized per user

### Access Control

- Default IAM roles for authenticated and guest users
- Rule-based role assignment based on user ID
- User access partitioning using policy variables
- Credentials obtained through AWS STS (Security Token Service)
- Roles require a trust policy for Cognito Identity Pools

### Policy Examples

#### Guest User Access Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:GetObject"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::mybucket/assets/my_picture.jpg"]
    }
  ]
}
```

#### User-Specific S3 Access Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:ListBucket"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::mybucket"],
      "Condition": {
        "StringLike": {
          "s3:prefix": ["${cognito-identity.amazonaws.com:sub}/*"]
        }
      }
    },
    {
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::mybucket/${cognito-identity.amazonaws.com:sub}/*"]
    }
  ]
}
```
