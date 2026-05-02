# Access EC2 Methods

## EC2 Instance Connect

EC2 Instance Connect provides a simple and secure way to connect to your EC2 instances. Below are the three main methods to connect using this service.

### Prerequisites

- EC2 Instance Connect must be [installed](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-set-up.html) on the instance (pre-installed on many AMIs)
- Appropriate IAM permissions must be configured for users
- Security group rules must allow SSH access (TCP port 22)

### 1. Connect via AWS Console

<details>
<summary><b>Requirements</b></summary>

- Instance must have either:
  - Public IPv4 address, or
  - Public IPv6 address
- Security group must allow inbound SSH traffic from AWS prefix lists:
  - IPv4: `com.amazonaws.region.ec2-instance-connect`
  - IPv6: `com.amazonaws.region.ipv6.ec2-instance-connect`
  </details>

### 2. Connect using AWS CLI

<details>
<summary><b>Connection Types</b></summary>

#### Auto Method

Automatically selects connection type based on available IP addresses:

1. Public IPv4 (using direct)
2. Private IPv4 (using eice)
3. Public IPv6 (using direct)

#### Direct Method

```bash
aws ec2-instance-connect ssh --instance-id i-1234567890abcdef0 --connection-type direct
```

Requirements:

- IAM permissions for [EC2 Instance Connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-configure-IAM-role.html)
- SSH client installed
- Network Configuration:
  - Inbound SSH access from user's IP
  - For public IP: Instance in public subnet with internet access
  - For private IP: VPC connectivity via Direct Connect, VPN, or VPC Peering

#### EICE Method (EC2 Instance Connect Endpoint)

Requirements:

- IAM permissions for [EC2 Instance Connect Endpoint](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/permissions-for-ec2-instance-connect-endpoint.html)
- EC2 Instance Connect Endpoint configured in VPC
- IPv4 only (IPv6 not supported)

Network Configuration:

- Endpoint Security Group:
  - Outbound: Allow TCP/22 to target instances
  - Can specify target security group or VPC CIDR
- Target Instance Security Group:
  - Inbound: Allow traffic from endpoint
  - Rules vary based on client IP preservation setting
  </details>

### 3. Connect using SSH

<details>
<summary><b>Requirements and Steps</b></summary>

#### Key Pair Requirements

- Supported Types: RSA (OpenSSH and SSH2), ED25519
- Key Lengths: 2048 or 4096 bits
- Network requirements same as Direct Method

#### Connection Steps

1. Generate SSH Keys (if needed)

```bash
ssh-keygen -t rsa -f my_key
```

2. Upload Public Key

```bash
aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id i-001234a4bf70dec41EXAMPLE \
    --instance-os-user ec2-user \
    --ssh-public-key file://my_key.pub
```

3. Connect via SSH

```bash
ssh -o "IdentitiesOnly=yes" -i my_key ec2-user@ec2-198-51-100-1.compute-1.amazonaws.com
```

</details>

### Troubleshooting

For connection issues, refer to the [EC2 Instance Connect Troubleshooting Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html#ic-troubleshoot)

## Session Manager

## SSH/RDP

## EC2 Serial Console
