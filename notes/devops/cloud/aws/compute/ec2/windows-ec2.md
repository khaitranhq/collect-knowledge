# EC2 Windows instances

## Commands to create Key Pair for importing

```
ssh-keygen -m PEM
```

## Windows launch agent

| Feature                                | EC2Launch                                            | EC2Launch v2                                         | EC2Config                                                     |
| -------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------- |
| **Supported OS Versions**              | Windows Server 2016 and 2019                         | Windows Server 2016 and later                        | Windows Server 2003 R2 to 2012 R2                             |
| **Dynamic Disk Management**            | Yes                                                  | Yes                                                  | Yes                                                           |
| **Instance Metadata Service (IMDSv2)** | No                                                   | Yes                                                  | No                                                            |
| **Configurable via YAML**              | No                                                   | Yes                                                  | No                                                            |
| **Log Location**                       | `C:\ProgramData\Amazon\EC2Launch\Logs\EC2Launch.log` | `C:\ProgramData\Amazon\EC2Launch\Logs\EC2Launch.log` | `C:\Program Files\Amazon\Ec2ConfigService\Logs\Ec2Config.log` |
| **Custom Scripts at Launch**           | Yes                                                  | Yes                                                  | Yes                                                           |
| **User Data Execution**                | Yes                                                  | Yes                                                  | Yes                                                           |
| **IPv6 Support**                       | No                                                   | Yes                                                  | No                                                            |
| **Elastic Network Adapter (ENA)**      | Yes                                                  | Yes                                                  | No                                                            |
| **Replace Network Adapter**            | Yes                                                  | Yes                                                  | No                                                            |
| **Hot Swap Drivers**                   | No                                                   | Yes                                                  | No                                                            |
| **Supported File Formats**             | INI                                                  | YAML                                                 | INI                                                           |
| **Initial Setup Tasks**                | Yes                                                  | Yes                                                  | Yes                                                           |

### EC2Launch v2

- Supported images
  - Windows Server 2022 and Windows Server 2025
  - Windows Server 2016 and 2019 with name `EC2LaunchV2-Windows_Server-*`

### EC2Launch

- Supported images: Windows Server 2016 and 2019 AMIs.

### EC2Config

- Supported images: Prior to Windows Server 2016
