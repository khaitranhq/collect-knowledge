# API Gateway Security Guidelines

## User Authentication

- **IAM Roles**: Useful for internal applications.
- **Cognito**: Provides identity for external users (e.g., mobile users).
- **Custom Authorizer**: Allows you to implement your own authentication logic.

## Custom Domain Name HTTPS Security

- Integration with **AWS Certificate Manager (ACM)** is required.
  - **Edge-Optimized Endpoint**: The certificate must be in the `us-east-1` region.
  - **Regional Endpoint**: The certificate must be in the same region as the API Gateway.

## DNS Configuration

- Set up a **CNAME** or **A-alias** record in **Route 53**.

## Resource Policies

![](/assets/2025-04-15-22-23-47.png)

## Throttling

- **Account Limit**:

  - API Gateway throttles requests at **10,000 RPS** across all APIs.
  - This is a soft limit that can be increased upon request.

- **Throttling Behavior**:

  - In case of throttling, a `429 Too Many Requests` error is returned (retriable error).

- **Performance Optimization**:

  - Set **Stage limits** and **Method limits** to improve performance.
  - Define **Usage Plans** to throttle requests per customer.

- **Important Note**:
  - An overloaded API Gateway that is not limited can cause other APIs to be throttled.
