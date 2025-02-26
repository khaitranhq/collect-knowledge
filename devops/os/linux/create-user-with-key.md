# Creating Linux User with SSH Key Authentication

This guide explains how to create a new Linux user and set up SSH key-based authentication.

## 1. Create a New User

```bash
# Create a new user
sudo useradd -m -s /bin/bash username

# Set password for the new user (you'll be prompted to enter a password)
sudo passwd username

# Add user to sudo group (optional - if you want to give sudo privileges)
sudo usermod -aG sudo username
```

## 2. Generate SSH Key Pair

On your local machine (not the server), generate an SSH key pair:

```bash
# Generate RSA key pair (4096 bits for better security)
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"

# Or generate Ed25519 key pair (recommended, more secure and modern)
ssh-keygen -t ed25519 -C "your.email@example.com"
```

The keys will be generated in:

- Private key: `~/.ssh/id_rsa` or `~/.ssh/id_ed25519`
- Public key: `~/.ssh/id_rsa.pub` or `~/.ssh/id_ed25519.pub`

## 3. Set Up Public Key Authentication

### Method 1: Using ssh-copy-id (Recommended)

```bash
# Copy public key to remote server
ssh-copy-id username@remote_host
```

### Method 2: Manual Setup

If `ssh-copy-id` is not available, follow these steps:

```bash
# On the server, create .ssh directory for the user
sudo mkdir -p /home/username/.ssh
sudo chown username:username /home/username/.ssh
sudo chmod 700 /home/username/.ssh

# Copy your public key content to authorized_keys file
echo "your_public_key_content" | sudo tee /home/username/.ssh/authorized_keys
sudo chown username:username /home/username/.ssh/authorized_keys
sudo chmod 600 /home/username/.ssh/authorized_keys
```

## 4. Test the Connection

```bash
# Try to connect using SSH key
ssh username@remote_host
```

## Security Best Practices

1. Disable password authentication (optional but recommended):

   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

   Set the following:

   ```
   PasswordAuthentication no
   ChallengeResponseAuthentication no
   ```

   Then restart SSH service:

   ```bash
   sudo systemctl restart sshd
   ```

2. Protect your private key:

   - Never share your private key
   - Use a strong passphrase when generating keys
   - Keep private key permissions restricted (chmod 600)

3. Regular key rotation:
   - Periodically generate new key pairs
   - Remove old or unused keys from authorized_keys

## Troubleshooting

If you can't connect:

1. Check file permissions
2. Verify public key is correctly added to authorized_keys
3. Check SSH service status: `sudo systemctl status sshd`
4. Review SSH logs: `sudo tail -f /var/log/auth.log` or `sudo journalctl -u sshd`
