# Install AWS Load Balancer Controller with Helm

## Prerequisites 📋

- **Amazon EKS Cluster**: Existing and running
- **IAM OIDC Provider**: Ensure it's set up for your cluster ([Create an IAM OIDC provider](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html))
- **Amazon VPC CNI Plugin**: Ensure it's at the minimum required version
- **Kube-proxy and CoreDNS Add-ons**: Ensure they are at the minimum required versions
- **AWS Elastic Load Balancing**: Basic familiarity
- **Kubernetes Service and Ingress Resources**: Basic familiarity
- **Helm**: Installed locally

## Install

Refer [this](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
