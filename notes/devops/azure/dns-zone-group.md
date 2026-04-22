# DNS Zone Group

## What It Is

A DNS Zone Group is an Azure Private DNS configuration that links a Virtual Network to a Private DNS Zone. It enables automatic DNS name resolution within private networks without requiring manual DNS server configuration.

**Key feature**: It **automatically creates A records** for resources in the linked Virtual Network, eliminating the need to manually register DNS entries. When you provision a resource, its A record is automatically added to the DNS Zone.

## Key Benefits

- **Automatic DNS Resolution** - Resources in linked VNets automatically resolve private DNS names
- **No Manual DNS Configuration** - Eliminates the need to configure custom DNS servers on VNets
- **Simplified Networking** - Centralized DNS management across multiple Virtual Networks
- **Hybrid Connectivity** - Supports DNS resolution for on-premises resources connected via ExpressRoute or Site-to-Site VPN
- **Zero Configuration for Resources** - VMs and services work with DNS automatically without needing custom DNS settings
- **Multi-VNet Support** - Link multiple Virtual Networks to the same DNS Zone for consistent name resolution
