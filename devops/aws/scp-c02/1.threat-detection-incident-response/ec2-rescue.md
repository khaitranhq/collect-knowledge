# EC2 Rescue

## EC2Rescue Tool for Linux 🐧

### Use Cases

- **Collect System Utilization Reports**
  - Tools: `vmstat`, `iostat`, `mpstat`, etc.
- **Collect Logs and Details**
  - Logs: `syslog`, `dmesg`, application error logs, SSM logs
- **Detect System Problems**
  - Issues: Asymmetric routing, duplicate root device labels
- **Automatically Remediate System Problems**
  - Fixes: Correcting OpenSSH file permissions, disabling known problematic kernel modules
- **Custom Modules**
  - Create your own custom module for specific needs

## EC2Rescue Tool for Windows Server 🪟

### Features

- **Diagnose and Troubleshoot Common Issues**
  - Collect log files, troubleshoot issues, provide suggestions
- **Supports Two Modules**
  - Data Collector
  - Analyzer
- **Compatibility**
  - Windows Server 2008 R2 or later

### Installation

- **[Manual Installation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Windows-Server-EC2Rescue.html)**
- **Using AWS Systems Manager**
  - Document: `AWSSupport-RunEC2RescueForWindowsTool`
  - Commands: `CollectLogs`, `FixAll`, `ResetAccess`

### Usage

- **Run Command Document**
  - Use `AWSSupport-ExecuteEC2Rescue` to run `AWSSupport-RunEC2RescueForWindowsTool`
- **Automation Document**
  - Troubleshoot connectivity issues

### Additional Features

- **Upload Results**
  - Directly upload the results to an S3 bucket
