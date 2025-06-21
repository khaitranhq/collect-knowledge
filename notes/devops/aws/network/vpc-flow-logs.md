# VPC Flow Logs

VPC Flow Logs is a feature that enables you to capture information about the IP traffic going to and from network interfaces in your VPC.

## Traffic Not Captured by VPC Flow Logs

The following types of traffic are **not** captured in VPC Flow Logs:

- **DNS Traffic**: Traffic to Amazon DNS server (custom DNS server traffic is logged)
- **Windows Licensing**: Traffic for Amazon Windows license activation
- **Instance Metadata**: Traffic to and from 169.254.169.254 for EC2 instance metadata
- **Time Synchronization**: Traffic to and from 169.254.169.123 for Amazon Time Sync service
- **Network Management**: DHCP traffic
- **Traffic Mirroring**: Mirrored traffic
- **VPC Router**: Traffic to the VPC router reserved IP address (e.g., 10.0.0.1)
- **VPC Endpoints**: Traffic between VPC Endpoint ENI and Network Load Balancer ENI
