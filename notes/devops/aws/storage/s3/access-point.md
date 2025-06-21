# S3 Access Points

![S3 Access Points Overview](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-35-39.png)

## Overview

S3 Access Points simplify security management for S3 Buckets for applications in specific VPCs. Each Access Point has:

- Its own DNS name (Internet Origin or VPC Origin)
- An access point policy (similar to bucket policy) for managing security at scale

## VPC Access Points

![VPC Access Points](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-36-37.png)

When using Access Points with VPCs:

- Access points can be configured to be accessible only from within a VPC
- You must create a VPC Endpoint to access the Access Point (Gateway or Interface Endpoint)
- The VPC Endpoint Policy must allow access to the target bucket and Access Point

## Multi-Region Access Points

![Multi-Region Access Points](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-37-44.png)

Multi-Region Access Points provide:

- A global endpoint that spans S3 buckets in multiple AWS regions
- Dynamic routing of requests to the nearest S3 bucket (lowest latency)
- Bi-directional S3 bucket replication rules to keep data in sync across regions

### Failover Controls

![Failover Controls](/home/lewis/Workspaces/Personal/collect-knowledge/assets/2025-06-21-21-38-01.png)

Failover Controls allow you to:

- Shift requests across S3 buckets in different AWS regions within minutes
- Implement Active-Active or Active-Passive configurations
