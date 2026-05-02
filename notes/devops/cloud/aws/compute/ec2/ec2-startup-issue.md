# EC2 Startup Troubleshooting

## Instance Stops Immediately After Starting

### Quick Diagnostics

**Check state transition reason:**

```bash
aws ec2 describe-instances \
  --instance-ids i-1234567890abcdef0 \
  --query 'Reservations[].Instances[].StateReason'
```

**Review system logs:**

```bash
aws ec2 get-console-output \
  --instance-id i-1234567890abcdef0 \
  --output text
```

## Common Causes & Solutions

### 1. Encrypted EBS Volume with KMS Key Issues

**Problem:** IAM principal lacks KMS permissions to decrypt encrypted volumes.

**Error:** `Client.InternalError: Client error on launch`

**Solution:**

Check KMS key status:

```bash
# Get KMS key ID
aws ec2 describe-volumes \
  --volume-ids vol-1234567890abcdef0 \
  --query 'Volumes[0].KmsKeyId'

# Verify key is enabled
aws kms describe-key --key-id <key-id>
```

Grant required permissions (add to IAM policy):

```json
{
  "Effect": "Allow",
  "Action": ["kms:CreateGrant", "kms:Decrypt", "kms:DescribeKey", "kms:Encrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*"],
  "Resource": "arn:aws:kms:region:account:key/key-id"
}
```

**OR** add IAM principal to KMS key policy as "Key user" in AWS Console.

**⚠️ Important:**

- The principal who **starts** the instance needs permissions, not the instance role
- Do NOT use `aws:SourceIp` conditions in KMS policies for EBS encryption
- Key must be **enabled** and **symmetric**

### 2. User Data Shutdown Scripts

**Problem:** User data contains shutdown commands that execute on boot.

**Solution:**

```bash
# Check user data
aws ec2 describe-instance-attribute \
  --instance-id i-1234567890abcdef0 \
  --attribute userData --output text | base64 --decode

# Modify if needed (instance must be stopped)
aws ec2 modify-instance-attribute \
  --instance-id i-1234567890abcdef0 \
  --user-data file://new-user-data.txt
```

### 3. Shutdown Behavior Set to Terminate

**Problem:** Instance terminates instead of stopping on OS shutdown.

**Solution:**

```bash
# Check current behavior
aws ec2 describe-instance-attribute \
  --instance-id i-1234567890abcdef0 \
  --attribute instanceInitiatedShutdownBehavior

# Change to stop
aws ec2 modify-instance-attribute \
  --instance-id i-1234567890abcdef0 \
  --instance-initiated-shutdown-behavior stop
```

### 4. Volume Limit Exceeded

**Error:** `Client.VolumeLimitExceeded: Volume limit exceeded`

**Solution:**

- Delete unused volumes/snapshots
- Request quota increase via Service Quotas console

### 5. Insufficient Instance Capacity

**Error:** `InsufficientInstanceCapacity`

**Solution:**

- Try different Availability Zone
- Try different instance type
- Use Auto Scaling with multiple instance types/AZs

### 6. Auto Scaling Group Termination

**Problem:** ASG automatically terminates stopped instances.

**Solution:**

```bash
# Check if in ASG
aws autoscaling describe-auto-scaling-instances \
  --instance-ids i-1234567890abcdef0

# Detach from ASG
aws autoscaling detach-instances \
  --instance-ids i-1234567890abcdef0 \
  --auto-scaling-group-name my-asg \
  --no-should-decrement-desired-capacity
```

### 7. Corrupted AMI/Snapshot

**Solution:**

- Launch from different AMI
- Verify snapshot state is `completed`
- Recreate custom AMI if necessary

## Troubleshooting Checklist

- [ ] Check state transition reason and message
- [ ] Review system logs for errors
- [ ] Verify KMS key enabled (if encrypted EBS)
- [ ] Confirm IAM has `kms:CreateGrant` permission
- [ ] Check user data for shutdown commands
- [ ] Verify shutdown behavior is "stop"
- [ ] Confirm not in ASG with termination policies
- [ ] Check volume limits not exceeded
- [ ] Try different AZ if capacity issues

## Useful Commands

**Get instance details:**

```bash
aws ec2 describe-instances --instance-ids i-1234567890abcdef0
```

**View status checks:**

```bash
aws ec2 describe-instance-status --instance-ids i-1234567890abcdef0
```

**List attached volumes:**

```bash
aws ec2 describe-volumes \
  --filters Name=attachment.instance-id,Values=i-1234567890abcdef0
```

## References

- [AWS Docs: Troubleshoot instance launch issues](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/troubleshooting-launch.html)
- [AWS Docs: Resolve KMS permission issues](https://repost.aws/knowledge-center/kms-iam-ec2-permission)
- [AWS Docs: Troubleshoot instance stop issues](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesStopping.html)
