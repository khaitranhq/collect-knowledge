# DNS Resolution in VPC

## DNS Resolution (enableDnsSupport)

![DNS Resolution](/assets/2025-04-05-12-01-01.png)

## DNS Hostnames (enableDnsHostnames)

By default:

- True for default VPC
- False for newly created VPCs
- Won't do anything unless enableDnsSupport=true
- If True, assigns public hostname to EC2 instance if it has a public IPv4

![DNS Hostnames](/assets/2025-04-05-12-02-14.png)

## Route53 Private Hosted Zone

- To use Private Hosted Zone in a VPC, you must set both attributes (enableDnsSupport & enableDnsHostnames) to true
