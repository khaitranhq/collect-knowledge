# EC2 Instance Metadata Service (IMDS)

## What is IMDS?

The Instance Metadata Service (IMDS) is a component of Amazon EC2 that provides a way for EC2 instances to access instance-specific data without explicitly using AWS credentials. IMDS is an on-instance endpoint with the IP address `169.254.169.254` that can only be accessed from within the EC2 instance itself.

IMDS offers two versions:

- **IMDSv1**: The original, request/response method
- **IMDSv2**: A more secure, session-oriented method that protects against certain types of vulnerabilities

## What is IMDS Used For?

The Instance Metadata Service provides essential information and capabilities for EC2 instances:

1. **Instance Information**: Access details about the EC2 instance itself, such as:

   - Instance ID
   - Instance type
   - Local IP address
   - Public IP address
   - MAC address
   - AMI ID used to launch the instance
   - Security groups

2. **IAM Role Credentials**: When an IAM role is attached to an EC2 instance, applications running on the instance can obtain temporary security credentials through IMDS without having to manage API keys.

![](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-20-23-22-41.png)

3. **User Data**: Retrieve user data that was specified when launching the instance, which can be used for configuration scripts.

4. **Dynamic Data**: Access dynamic information such as instance identity documents and security credentials that are generated when an instance is launched.

5. **Networking Information**: Obtain details about the VPC, subnet, and other network configurations.

6. **Spot Instance Termination Notices**: For spot instances, check if the instance has been scheduled for termination.

IMDS is extensively used by AWS services, SDKs, CLI, and customer applications to operate effectively within the AWS environment without requiring explicit credential management.

## How to Use IMDSv1

IMDSv1 uses a simple request/response method that requires a single HTTP request.

### Basic Usage:

```bash
# Get a list of all available metadata categories:
curl http://169.254.169.254/latest/meta-data/

# Get the instance ID:
curl http://169.254.169.254/latest/meta-data/instance-id

# Get the instance type:
curl http://169.254.169.254/latest/meta-data/instance-type

# Get the public IP address:
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Get the security groups:
curl http://169.254.169.254/latest/meta-data/security-groups

# Get the IAM role name:
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Get temporary credentials for the IAM role:
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/YOUR_ROLE_NAME

# Access user data (if configured):
curl http://169.254.169.254/latest/user-data
```

### Limitations of IMDSv1:

IMDSv1 is vulnerable to server-side request forgery (SSRF) attacks, where a malicious actor could trick an application running on the instance to make requests to the metadata service, potentially exposing sensitive information.

## How to Use IMDSv2

IMDSv2 uses a session-oriented approach that requires two steps: creating a session token and then using that token in subsequent requests.

### Basic Usage:

Step 1: Create a session token (valid for up to 6 hours, TTL in seconds):

```bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
```

Step 2: Use the token in subsequent requests:

```bash
# Get a list of all available metadata categories:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/

# Get the instance ID:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id

# Get the instance type:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type

# Get the public IP address:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4

# Get the security groups:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/security-groups

# Get the IAM role name:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Get temporary credentials for the IAM role:
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/YOUR_ROLE_NAME

# Access user data (if configured):
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/user-data
```

### Benefits of IMDSv2:

1. **Increased Security**: Protects against SSRF vulnerabilities by requiring the PUT request and session token.
2. **Session-based**: Tokens have a configurable TTL, limiting the time window of potential exposure.
3. **HTTP Headers**: Uses standard HTTP headers which are typically restricted in web applications.

### Enforcing IMDSv2 on EC2 Instances:

To ensure only IMDSv2 is used on your instances, you can:

1. Configure the `HttpTokens` parameter to `required` when launching new instances
2. Modify existing instances to require IMDSv2:

```bash
aws ec2 modify-instance-metadata-options \
 --instance-id i-1234567890abcdef0 \
 --http-tokens required \
 --http-endpoint enabled
```

AWS recommends using IMDSv2 instead of IMDSv1 for all new applications and transitioning existing applications to IMDSv2 for enhanced security.
