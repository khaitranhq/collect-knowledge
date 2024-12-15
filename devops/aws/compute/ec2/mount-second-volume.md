# Mount second volume to EC2

## Steps

### Linux 🐧

1. 💾 **Attach Volume**

   - Attach the EBS volume to your EC2 instance through AWS Console or CLI

2. 🔌 **Connect to Instance**

   - SSH into your EC2 instance

3. 🔍 **Verify Volume**

   - Run `lsblk` to list block devices and verify the new volume
   - You should see your new volume (typically /dev/xvdf)

4. 📋 **Check File System**

   - Run `sudo file -s /dev/xvdf` to check if volume has a file system
   - If output shows `/dev/xvdf: data`, the volume needs formatting
   - Format with XFS: `sudo mkfs -t xfs /dev/xvdf`

5. 📁 **Create Mount Point**

   - Create directory: `sudo mkdir /data`

6. 🔗 **Mount Volume**
   - Mount the volume: `sudo mount /dev/xvdf /data`
   - Verify mount with: `df -h`

## Troubleshooting 🔧

<details>
<summary>❌ <b>mkfs.xfs command not found</b></summary>

Install XFS tools package:

- For Amazon Linux/RHEL/CentOS:
  ```bash
  sudo yum install xfsprogs
  ```
- For Ubuntu/Debian:
  ```bash
  sudo apt-get update
  sudo apt-get install xfsprogs
  ```
  </details>

<details>
<summary>❌ <b>Volume not showing up after attach</b></summary>

1. Verify volume attachment in AWS Console
2. Scan for new devices:
   ```bash
   sudo fdisk -l
   # or
   sudo lsblk
   ```
3. If still not visible, try:
   ```bash
   sudo systemctl restart systemd-udevd
   ```
   </details>

<details>
<summary>❌ <b>Permission denied during mount</b></summary>

1. Check if mount point exists and has correct permissions:
   ```bash
   ls -ld /data
   ```
2. Ensure you're using sudo:
   ```bash
   sudo mount /dev/xvdf /data
   ```
   </details>

<details>
<summary>❌ <b>Other errors</b></summary>

1. Check system logs for errors:
   ```bash
   dmesg | tail -20
   ```
2. View mount errors:
   ```bash
   sudo journalctl -u systemd-mount
   ```
3. Check disk status:
   ```bash
   sudo fdisk -l /dev/xvdf
   ```
   </details>
