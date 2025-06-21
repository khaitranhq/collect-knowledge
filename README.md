# My DevOps & Cloud Knowledge Base

A personal collection of notes, best practices, and guides for cloud technologies, DevOps practices, and software development.

![Total Notes](https://img.shields.io/badge/Total_Notes-74-blue)

## 📚 Quick Links

- [AWS S3 Performance Tips](notes/devops/aws/storage/s3/enhance-performance.md)
- [IAM Security Best Practices](notes/devops/aws/security/iam-abac.md)
- [GitHub Actions Tips](notes/devops/cicd/github-action-tips.md)

## 🔍 Table of Contents

<details open>
<summary>🧠 AI</summary>

- [AI Agent Overview](notes/ai/ai-agent-overview.md)
- [Useful Prompts](notes/ai/useful-prompts.md)
</details>

<details open>
<summary>💻 Coding</summary>

- **Golang**
  - [Error Handling Best Practices](notes/coding/golang/error-handling-best-practices.md)
- **TypeScript**
  - [Init Project](notes/coding/typescript/init-project.md)
  </details>

<details open>
<summary>🛠️ DevOps</summary>

<details>
<summary>☁️ AWS</summary>

<details>
<summary>Compute</summary>

- **API Gateway**
  - [Security](notes/devops/aws/compute/api-gateway/security.md)
- **EC2**
  - [Add User](notes/devops/aws/compute/ec2/add-user.md)
  - [Connect EC2 Methods](notes/devops/aws/compute/ec2/connect-ec2-methods.md)
  - [IMDS](notes/devops/aws/compute/ec2/imds.md)
  - [Lost EC2 Credentials](notes/devops/aws/compute/ec2/lost-ec2-credentials.md)
  - [Mount Second Volume](notes/devops/aws/compute/ec2/mount-second-volume.md)
  - [Windows EC2](notes/devops/aws/compute/ec2/windows-ec2.md)
- **ECS**
  - [Monitor ECS Containers With ECS Exec](notes/devops/aws/compute/ecs/monitor-ecs-containers-with-ecs-exec.md)
- **EKS**
  - [Add Cluster To ArgoCD](notes/devops/aws/compute/eks/add-cluster-to-argocd.md)
  - [Application Load Balancer](notes/devops/aws/compute/eks/application-load-balancer.md)
  - [IAM User Access Authentication](notes/devops/aws/compute/eks/iam-user-access-authentication.md)
  - [Install AWS Load Balancer Controller](notes/devops/aws/compute/eks/install-aws-load-balancer-controller.md)
- **Step Functions**
  - [Intrinsic Functions In Step Functions](notes/devops/aws/compute/step-function/intrinsic-functions-in-step-functions.md)
  </details>

<details>
<summary>Database</summary>

- **ElastiCache**
  - [Persistence](notes/devops/aws/database/elasticache/persistence.md)
- **RDS**
  - [Enable RDS Audit Log](notes/devops/aws/database/rds/enable-rds-audit-log.md)
  - [Export RDS Postgres S3](notes/devops/aws/database/rds/export-rds-postgres-s3.md)
  </details>

<details>
<summary>Development</summary>

- [CodeBuild Troubleshooting](notes/devops/aws/development/codebuild-troubleshooting.md)
</details>

<details>
<summary>Management</summary>

- [Best Practice Manage Instance With SSM](notes/devops/aws/management/best-practice-manage-instance-with-ssm.md)
- [CloudTrail](notes/devops/aws/management/cloudtrail.md)
- [EventBridge](notes/devops/aws/management/eventbridge.md)
- [Monitor Account Activity](notes/devops/aws/management/monitor-account-activity.md)
- [SSM Parameter Types](notes/devops/aws/management/ssm-parameter-types.md)
</details>

<details>
<summary>Monitoring</summary>

- [Athena Improve Performance](notes/devops/aws/monitoring/athena-improve-performance.md)
- **CloudWatch**
  - [CloudWatch Agent Procstat Plugin](notes/devops/aws/monitoring/cloudwatch/cloudwatch-agent-procstat-plugin.md)
  - [CloudWatch Agent Troubleshooting](notes/devops/aws/monitoring/cloudwatch/cloudwatch-agent-troubleshooting.md)
  - [Contributor Insights](notes/devops/aws/monitoring/cloudwatch/contributor-insights.md)
  </details>

<details>
<summary>Networking</summary>

- [Access And Query AWS Load Balancer Access Logs](notes/devops/aws/network/access-and-query-aws-load-balancer-access-logs.md)
- [Client VPN Authentication Types](notes/devops/aws/network/client-vpn-authentication-types.md)
- [DNS Resolution](notes/devops/aws/network/dns-resolution.md)
- [Site To Site VPN](notes/devops/aws/network/site-to-site-vpn.md)
- [VPC Endpoint](notes/devops/aws/network/vpc-endpoint.md)
- [VPC Flow Logs](notes/devops/aws/network/vpc-flow-logs.md)
</details>

<details>
<summary>Others</summary>

- [CloudFront Security](notes/devops/aws/others/cloudfront-security.md)
- [Cost Optimization For FinOps](notes/devops/aws/others/cost-optimization-for-finops.md)
- [Custom Resources](notes/devops/aws/others/custom-resources.md)
- [Quickly Create Lambda CDK](notes/devops/aws/others/quickly-create-lambda-cdk.md)
</details>

<details>
<summary>🔒 Security</summary>

- [Cognito](notes/devops/aws/security/cognito.md)
- [Deal With Compromised Resource](notes/devops/aws/security/deal-with-compromised-resource.md)
- [IAM ABAC](notes/devops/aws/security/iam-abac.md)
- [IAM Policy For AWS S3 Sync](notes/devops/aws/security/iam-policy-for-aws-s3-sync.md)
- [IAM Policy For Step Functions Triggering Other Step Functions](notes/devops/aws/security/iam-policy-for-step-functions-triggering-other-step-functions.md)
- [IAM Policy For The Role To Build And Push Docker To ECR](notes/devops/aws/security/iam-policy-for-the-role-to-build-and-push-docker-to-ecr.md)
- [IAM Policy To Access Fleet Manager](notes/devops/aws/security/iam-policy-to-access-fleet-manager.md)
- [IAM Policy To Manage Own User](notes/devops/aws/security/iam-policy-to-manage-own-user.md)
- [Revoke IAM Role Temporary Credentials](notes/devops/aws/security/revoke-iam-role-temporary-credentials.md)
</details>

<details>
<summary>Storage</summary>

- [Choose Right Storage Solution](notes/devops/aws/storage/choose-right-storage-solution.md)
- **S3**
  - [Access Point](notes/devops/aws/storage/s3/access-point.md)
  - [Check Object Integrity](notes/devops/aws/storage/s3/checkobject-integrity.md)
  - [Enhance Performance](notes/devops/aws/storage/s3/enhance-performance.md)
  - [Example S3 Policies](notes/devops/aws/storage/s3/example-s3-policies.md)
  - [Management](notes/devops/aws/storage/s3/management.md)
  - [Object Lock](notes/devops/aws/storage/s3/object-lock.md)
  - [Regain Access To Locked S3 Buckets](notes/devops/aws/storage/s3/regain-access-to-locked-s3-buckets.md)
  - [Security](notes/devops/aws/storage/s3/security.md)
  - [Storage Classes](notes/devops/aws/storage/s3/storage-classes.md)
  - [Troubleshooting](notes/devops/aws/storage/s3/troubleshooting.md)
  </details>
  </details>

<details>
<summary>🔄 CI/CD</summary>

- [GitHub Action Tips](notes/devops/cicd/github-action-tips.md)
- [Harden Security AWS GitHub OIDC](notes/devops/cicd/harden-security-aws-github-oidc.md)
</details>

<details>
<summary>🗄️ Database</summary>

- [Install PostgreSQL 16 On Amazon Linux 2023](notes/devops/database/install-postgres-16-on-amazon-linux-2023.md)
- [OpenSearch Cat Indices Permission](notes/devops/database/opensearch-cat-indices-permission.md)
</details>

<details>
<summary>🔐 DevSecOps</summary>

- [Roadmap](notes/devops/devsecops/roadmap.md)
- [Tool Scan Container](notes/devops/devsecops/tool-scan-container.md)
</details>

<details>
<summary>🐳 Docker</summary>

- [Docker Compose Containers Depend On Other Containers](notes/devops/docker/docker-compose-containers-depend-on-other-containers.md)
</details>

<details>
<summary>💻 OS</summary>

- **Linux**
  - **CentOS**
    - **6**
      - [Setup VNC](notes/devops/os/linux/centos/6/setup-vnc.md)
  - [Create User With Key](notes/devops/os/linux/create-user-with-key.md)
  - [Disk Management](notes/devops/os/linux/disk-management.md)
  - [Install Docker AL2023](notes/devops/os/linux/install-docker-al2023.md)
  </details>
  </details>

<details open>
<summary>🛠️ Tools</summary>

- **Eraser**
  - [Cloud Architecture Syntax](notes/tools/eraser/cloud-architecture-syntax.md)
  - [Flow Chart Syntax](notes/tools/eraser/flow-chart-syntax.md)
- **Nvim**
  - [DOS File On WSL](notes/tools/nvim/dos-file-on-wsl.md)
  </details>

## 🆕 Recently Added Notes

- [Tool Scan Container](notes/devops/devsecops/tool-scan-container.md)
- [Install Docker AL2023](notes/devops/os/linux/install-docker-al2023.md)
- [OpenSearch Cat Indices Permission](notes/devops/database/opensearch-cat-indices-permission.md)

## 🔎 How to Use This Knowledge Base

- Click on any section to explore topics
- Use browser search (Ctrl+F or Cmd+F) to find specific topics
- All notes are markdown files that can be viewed directly on GitHub or in any markdown reader
