# AWS account + project onboarding checklist

Use this when creating a brand new AWS account and starting a new workload. Focus: high-value first actions that reduce security risk, improve visibility, and avoid expensive cleanup later.  
Keep it simple: do mandatory items first, then recommended, then optional items when maturity grows.

**Legend:** **Mandatory** = do before real usage · **Recommended** = do early · **Optional** = useful, but can wait

## Phase 1 - Account foundation (new AWS account)

### Identity and root account

- [ ] **Mandatory**: Protect the **root user** with a long unique password stored in a password manager.
- [ ] **Mandatory**: Enable **MFA on root** immediately (prefer hardware key if possible).
- [ ] **Mandatory**: Do **not** use root for daily work. Keep root for break-glass/admin-only tasks.
- [ ] **Mandatory**: Create at least one emergency recovery path for root access and document who can use it.
- [ ] **Mandatory**: Use **IAM Identity Center** (AWS SSO) for human access instead of long-lived IAM users.
- [ ] **Recommended**: Create separate user group, e.g `admin`, `power-user`, `read-only`, and `billing`.
- [ ] **Recommended**: Require MFA for all human users via Identity Center.

### Billing and cost guardrails

- [ ] **Mandatory**: Enable **AWS Budgets** for monthly spend and alert to email/Slack at useful thresholds.
- [ ] **Mandatory**: Turn on **Cost Explorer** and check forecast/breakdown early.
- [ ] **Mandatory**: Set billing alarms for unusual daily spend spikes.
- [ ] **Mandatory**: Define required **cost allocation tags** such as `Project`, `Owner`, `Environment`, `DataClass`, and `CostCenter`.
- [ ] **Recommended**: Block or review expensive services/regions by policy if not needed.

## Phase 2 - Baseline security, logging, and guardrails (account-level)

### Logging and audit

- [ ] **Mandatory**: Enable **organization/account CloudTrail** in all regions, including global service events.
- [ ] **Mandatory**: Send CloudTrail logs to a protected central S3 bucket in a log archive account if possible.
- [ ] **Mandatory**: Enable **CloudTrail log file validation**.
- [ ] **Mandatory**: Turn on **AWS Config** to record resource configuration and drift.
- [ ] **Recommended**: Send important audit events to **CloudWatch Logs** / EventBridge for alerting.
- [ ] **Recommended**: Start with a small set of high-value Config rules instead of enabling everything blindly.

### Threat detection and security posture

- [ ] **Mandatory**: Enable **GuardDuty** in all accounts/regions you use.
- [ ] **Mandatory**: Review default security contacts and incident notification paths.
- [ ] **Recommended**: Enable **Security Hub** and aggregate findings centrally.
- [ ] **Recommended**: Turn on **IAM Access Analyzer** to detect unintended external/public access.
- [ ] **Recommended**: Enable **Detective** if your team will actively investigate incidents.

### Encryption and key management

- [ ] **Mandatory**: Enforce encryption at rest for core data stores and S3 buckets.
- [ ] **Mandatory**: Prefer **KMS** for managed encryption where supported.
- [ ] **Recommended**: Use customer-managed KMS keys for sensitive or regulated data.
- [ ] **Recommended**: Control who can administer keys separately from who can use encrypted data.
- [ ] **Mandatory**: Require TLS for data in transit and avoid plaintext service endpoints.

### Networking baseline

- [ ] **Mandatory**: Decide allowed AWS regions up front and limit usage if possible.
- [ ] **Mandatory**: Start with a simple VPC pattern with public/private subnet separation.
- [ ] **Mandatory**: Keep workloads in **private subnets** unless public exposure is truly required.
- [ ] **Recommended**: Use **security groups** as primary network control; keep them narrow and documented.
- [ ] **Recommended**: Avoid broad `0.0.0.0/0` inbound rules except where intentionally public.
- [ ] **Recommended**: Plan egress control early for sensitive workloads (NAT, proxy, or VPC endpoints as needed).

### Backup and recovery baseline

- [ ] **Mandatory**: Enable **AWS Backup** or service-native backups for supported data stores.
- [ ] **Mandatory**: Define backup retention for prod and non-prod separately.
- [ ] **Mandatory**: Turn on backup encryption.
- [ ] **Recommended**: Test restore at least once early; backup without restore testing is weak assurance.
- [ ] **Recommended**: Keep copies in another account and/or region for critical workloads.

### Operational readiness baseline

- [ ] **Mandatory**: Create a minimal incident response runbook: who to call, where alerts go, how to revoke access, how to capture evidence.
- [ ] **Recommended**: Pre-create break-glass roles with strong controls and logging.
- [ ] **Recommended**: Define a standard tagging policy and enforce it in IaC/pipelines.
- [ ] **Recommended**: Use infrastructure as code from day 1 (CloudFormation, Terraform, or Pulumi) instead of console-only setup.

## Phase 3 - New workload / project setup

### Access model and IAM

- [ ] **Mandatory**: Create workload-specific roles for humans and machines; avoid shared admin roles.
- [ ] **Mandatory**: Follow least privilege for app roles, CI/CD roles, and support roles.
- [ ] **Mandatory**: Do not create long-lived access keys unless unavoidable; prefer role assumption.
- [ ] **Recommended**: Separate deploy role from runtime role.
- [ ] **Recommended**: Review permissions with **IAM Access Analyzer** and remove unused/broad access.

### Secrets and CI/CD

- [ ] **Mandatory**: Store secrets in **AWS Secrets Manager** or **SSM Parameter Store**, not in code, CI variables, AMIs, or container images.
- [ ] **Mandatory**: Rotate high-value secrets and credentials.
- [ ] **Mandatory**: Give CI/CD its own role with short-lived credentials via OIDC/federation where possible.
- [ ] **Recommended**: Add pipeline checks for IaC scan, dependency scan, secret scan, and policy validation.
- [ ] **Recommended**: Require approval gates for production changes.
- [ ] **Recommended**: Log deployment activity and tie it to change tickets/issues if your team uses them.

### Network and exposure for workload

- [ ] **Mandatory**: Put internet-facing apps behind managed entry points such as **ALB**, **API Gateway**, or **CloudFront**.
- [ ] **Recommended**: Add **AWS WAF** for public HTTP workloads.
- [ ] **Mandatory**: Expose only required ports/protocols.
- [ ] **Recommended**: Use VPC endpoints for AWS service access when it reduces internet exposure.
- [ ] **Recommended**: Separate prod/non-prod networks and data paths.

### Data protection

- [ ] **Mandatory**: Classify workload data at least as `public`, `internal`, `confidential`, or similar.
- [ ] **Mandatory**: Encrypt storage by default (S3, EBS, RDS, EFS, snapshots, backups).
- [ ] **Mandatory**: Turn on S3 protections: block public access, bucket encryption, versioning where useful.
- [ ] **Recommended**: Enable access logging/audit logging for critical data stores.
- [ ] **Recommended**: Minimize data retention; delete what you do not need.

### Observability and alerting

- [ ] **Mandatory**: Define core CloudWatch alarms before launch: CPU/memory/disk, 5xx errors, latency, queue depth, deployment failures, backup failures.
- [ ] **Mandatory**: Centralize application and infrastructure logs.
- [ ] **Recommended**: Use structured logs with request IDs / correlation IDs.
- [ ] **Recommended**: Create a basic dashboard for service health, error rate, latency, and cost.
- [ ] **Recommended**: Route alerts to on-call channels with ownership defined.

### Reliability and recovery

- [ ] **Mandatory**: Decide target availability and recovery goals: **RTO** and **RPO**.
- [ ] **Mandatory**: Remove single points of failure for production workloads where practical.
- [ ] **Recommended**: Use Multi-AZ managed services for stateful production systems.
- [ ] **Recommended**: Document restart, failover, and restore procedures.
- [ ] **Recommended**: Run one small game day / failure test before calling workload production-ready.

### Cost and hygiene for workload

- [ ] **Mandatory**: Tag every resource with `Project`, `Environment`, `Owner`, and `ManagedBy`.
- [ ] **Recommended**: Set per-project budget alerts.
- [ ] **Recommended**: Right-size early; do not leave default oversized instances in place.
- [ ] **Recommended**: Prefer managed/serverless services when they reduce ops burden and fit workload patterns.
- [ ] **Recommended**: Set lifecycle policies for S3, logs, snapshots, and container images.

## Phase 4 - Pre-production readiness check

- [ ] **Mandatory**: Confirm CloudTrail, Config, GuardDuty, budgets, backups, and alarms are active in target account/region.
- [ ] **Mandatory**: Confirm IAM roles and resource policies have been reviewed for least privilege and public exposure.
- [ ] **Mandatory**: Confirm secrets are externalized and no credentials exist in repo or pipeline config.
- [ ] **Mandatory**: Confirm restore procedure has been tested for at least one critical dataset.
- [ ] **Mandatory**: Confirm on-call/contact path exists for security and operational alerts.
- [ ] **Recommended**: Record a short architecture note: data flows, trust boundaries, key AWS services, owners, and recovery plan.

## Common mistakes

- Using **root** for daily work or leaving root without MFA
- Keeping everything in one account, especially mixing prod and non-prod
- Creating IAM users/access keys for humans instead of using **IAM Identity Center**
- Enabling security services in one region only and assuming coverage everywhere
- No budget alarms -> surprise bill
- No tested backup restore -> false sense of safety
- Public S3 buckets/security groups by accident
- Secrets stored in code, CI variables, AMIs, or container images
- No tagging standard -> hard cost tracking, ownership, cleanup
- Building by click-ops first, then struggling to reproduce with IaC later
