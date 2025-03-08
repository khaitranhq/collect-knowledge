# AWS Client VPN – Authentication Types

AWS Client VPN supports multiple authentication methods to secure access to your VPN endpoints.

![AWS Client VPN Authentication Types](../../assets/2025-03-08-21-33-46.png)

## Active Directory Authentication

- **User-Based Authentication** through Microsoft Active Directory
- Supports both AWS Managed Microsoft AD and on-premises AD through AD Connector
- Includes Multi-Factor Authentication (MFA) support

## Mutual Authentication

- **Certificate-Based Authentication** using certificates to verify identity
- Server certificate must be uploaded to AWS Certificate Manager
- Best practice: Provision one client certificate per user

## Single Sign-On (SSO)

- Supports IAM Identity Center / AWS SSO
- **User-Based Authentication** through SAML 2.0-based identity providers
- Requires establishing a trust relationship between AWS and the identity provider
- Limited to one identity provider at a time
