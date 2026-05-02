# 👥 Adding Users to EC2 Instances

## 📋 Prerequisites

- An EC2 instance running Linux
- SSH access to the instance
- Root or sudo privileges

## 🔧 Steps to Add a New User

### 1. Connect to Your EC2 Instance

```bash
ssh -i /path/to/key.pem ec2-user@your-instance-ip
```

### 2. Create a New User

```bash
# Create user
sudo useradd username

# Set password (optional)
sudo passwd username
```

### 3. Configure User Access

#### Option A: Add to Sudo Group

```bash
# Add user to sudo group
sudo usermod -aG sudo username  # For Ubuntu
# OR
sudo usermod -aG wheel username # For Amazon Linux/CentOS
```

#### Option B: Configure SSH Access

```bash
# Create .ssh directory for the new user
sudo mkdir -p /home/username/.ssh

# Create authorized_keys file
sudo touch /home/username/.ssh/authorized_keys

# Add public key to authorized_keys
sudo nano /home/username/.ssh/authorized_keys
# Paste your public key here

# Set correct permissions
sudo chmod 700 /home/username/.ssh
sudo chmod 600 /home/username/.ssh/authorized_keys
sudo chown -R username:username /home/username/.ssh
```

## 🔍 Verify User Setup

```bash
# Switch to new user
su - username

# Test sudo access (if configured)
sudo whoami
```

## ⚠️ Security Best Practices

- Always use strong passwords
- Limit sudo access to necessary users only
- Regularly audit user accounts
- Consider using SSH keys instead of passwords
- Implement proper file permissions

## 📝 Additional Notes

- For production environments, consider using IAM roles and AWS Systems Manager for user management
- Document all user additions and removals
- Follow your organization's security policies
