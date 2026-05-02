# Compromised Resources

## Common Steps

- Identify compromised resources
- Isolate resources
- Trace the activity
- Evaluate the effect

## Compromised Services

### EC2 Instances

![compromised-ec2](/assets/2025-01-16-21-50-26.png)

#### Steps to Address

- Capture the instance's metadata
- Enable Termination Protection
- Isolate the instance (replace instance's SG - no outbound traffic allowed)
- Detach the instance from any ASG (Suspend processes)
- Deregister the instance from any ELB
- Snapshot the EBS volumes (deep analysis)
- Tag the EC2 instance (to mark this instance as compromised)

#### Investigation Types

- **Offline investigation**: shutdown instance and investigate with the EBS snapshot (by creating a new one from this EBS snapshot)
- **Online investigation**: investigate the compromised instance

### S3 Buckets

![compromised-s3](/assets/2025-01-16-21-53-35.png)

- Identify bucket by **GuardDuty**
- Identify source by **CloudTrail** or **Detective**
- Recommended settings:
  - Block public access
  - Bucket policies & User policies
  - VPC endpoints
  - Pre-signed URLs
  - Access Points
  - ACLs

### ECS

- Identify the affected cluster by **GuardDuty**
- Identify source of the malicious activity
- Isolate the impacted tasks
- Evaluate the presence of malicious activity
