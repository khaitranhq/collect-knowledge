# S3 Troulbeshooting

## Monitoring

- AWS CloudWatch Alarms based on metrics
- AWS CloudTrail logs
- AWS S3 dashboard
- Trusted Advisor (for > Business Support plan only)

## General Problem Determination

- Identify problem
- Collect data
- Analyze data
- Review documentation
- Try known solutions

### 403 errors

- IAM and bucket policies
- Bucket settings
  - Bucket encryption
  - Public access blocked
  - Access point IAM policy
  - Request payer settings
  - Object Ownership
- AWS Organizations Service Control Policy
- Interface or Gateway VPC endpoints policies
- Other checks
  - Object isn't missing or object's name contains special characters

### Other errors

#### 500 errors

- Use retry mechanism
- Increase request rates gradually
- Monitor the number of 500 internal error responses
- Copy data using alternative methods.

#### 503 errors

- Use retry mechanism
- Increase request rates gradually
- Distribute objects across multiple prefixes
- Check if the objects requested has millions of versions

#### Lifecycle policies not actioned

- Be sure the lifecycle rule is enabled
- Check lifecycle rule scope
- Multiple lifecycle rules
- Lifecycle expirations

#### Replication

##### How do I troubleshoot

- Replication time & status
- Configuration
- Versioning
- Replication constraints
