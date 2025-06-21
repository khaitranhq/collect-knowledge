# Mount second volume to EC2

## Linux 🐧

### Steps

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

### Troubleshooting 🔧

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
   <summary>❌ <b>UUID of volumes are identical</b></summary>

- For XFS volumes, you can use the `xfs_admin` command to change the UUID of the volume.
  ```bash
  sudo xfs_admin -U generate /dev/xvdf
  ```
- For ext4 volumes, you can use the `tune2fs` command to change the UUID of the volume.
  ```bash
  sudo tune2fs /dev/xvdf -U random
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

## Windows 🪟

### Steps

There are 2 ways to mount a volume in Windows:

#### PowerShell Method 💻

1. 🔌 **Connect to Instance**

   - Log in to your Windows instance using Remote Desktop

2. 🚀 **Launch PowerShell**

   - Open Start menu
   - Choose Windows PowerShell (Run as Administrator)

3. 💽 **Initialize and Mount Volume**

   Run the following PowerShell commands:

   ```ps1
   # Stop disk detection service
   Stop-Service -Name ShellHWDetection

   # Initialize and format the disk
   Get-Disk |
       Where-Object PartitionStyle -eq 'raw' |
       Initialize-Disk -PartitionStyle MBR -PassThru |
       New-Partition -AssignDriveLetter -UseMaximumSize |
       Format-Volume `
           -FileSystem NTFS `
           -NewFileSystemLabel "Data Drive" `
           -Confirm:$false

   # Restart disk detection service
   Start-Service -Name ShellHWDetection
   ```

#### DiskPart command line tool

##### Steps

1. 🔌 **Connect to Instance**

   - Log in to your Windows instance using Remote Desktop

2. 🔍 **Identify Disk Number**

   - Open PowerShell
   - Run command to list disks:
     ```powershell
     Get-Disk
     ```
   - Note the disk number of your new volume

3. 📝 **Create DiskPart Script**

   - Open File Explorer
   - Navigate to C:\ or preferred location
   - Create new text file named `diskpart.txt`
   - Add the following commands:
     ```batch
     # Replace disk number, volume label, and drive letter as needed
     select disk 1
     attributes disk clear readonly
     online disk noerr
     convert mbr
     create partition primary
     format quick fs=ntfs label="Data Drive"
     assign letter=D
     ```

4. ⚡ **Execute DiskPart Script**
   - Open Command Prompt as Administrator
   - Navigate to script location:
     ```cmd
     cd C:\
     diskpart /s diskpart.txt
     ```

##### What Each Command Does 🔧

- `select disk 1` - Targets the specified disk number
- `attributes disk clear readonly` - Removes read-only flag
- `online disk noerr` - Brings disk online
- `convert mbr` - Sets MBR partition style
- `create partition primary` - Creates primary partition
- `format quick fs=ntfs` - Formats with NTFS filesystem
- `assign letter` - Assigns drive letter

⚠️ **Warning**: Don't format if the volume contains existing data!

##### Verification ✅

After mounting, verify the disk is available:

```cmd
diskpart
list volume
exit
```

#### Disk Management utility

1. 🔌 **Connect to Instance**

   - Log in to your Windows instance using Remote Desktop

2. 🚀 **Launch Disk Management**

   - Right-click Windows logo on taskbar
   - Select "Disk Management"
     > Note: On Windows Server 2008, go to: Start → Administrative Tools → Computer Management → Disk Management

3. 🔄 **Bring Volume Online**

   - Locate the new disk in the lower pane
   - Right-click the left panel of the disk
   - Select "Online"

4. ⚙️ **Initialize Disk** (if needed)

   - Right-click the left panel of the disk
   - Select "Initialize Disk"
   - Choose partition style (MBR or GPT)
   - Click OK

   ⚠️ **Warning**: Skip initialization if the volume contains existing data!

5. 📁 **Create Volume**

   - Right-click the right panel of the disk
   - Select "New Simple Volume"
   - Follow the New Simple Volume Wizard:
     1. Click Next to start
     2. Set volume size (default: maximum)
     3. Assign drive letter
     4. Set format options:
        - File system: NTFS
        - Allocation unit size: Default
        - Volume label: Enter name
        - Perform quick format: Checked
     5. Review and click Finish

6. ✅ **Verify Mount**
   - Open File Explorer
   - Check if new drive appears
   - Verify drive properties and capacity
