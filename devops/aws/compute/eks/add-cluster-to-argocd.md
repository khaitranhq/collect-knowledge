# Add an EKS Cluster to Argo CD with IRSA & argocd-k8s-auth

This guide explains how to securely add an EKS cluster to Argo CD using IAM Roles for Service Accounts (IRSA) and argocd-k8s-auth.

---

## 📋 Prerequisites

- Argo CD deployed in an EKS cluster with IRSA enabled
- OIDC provider configured in EKS
- AWS CLI access
- `argocd-k8s-auth` enabled in Argo CD
- IAM roles for:
  - Argo CD management
  - Each EKS cluster added to Argo CD

---

## 🔐 1. Create the Argo CD Management Role (IRSA)

Create an IAM role trusted by the Argo CD OIDC provider and by itself:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ExplicitSelfRoleAssumption",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnLike": {
          "aws:PrincipalArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ARGO_CD_MANAGEMENT_IAM_ROLE_NAME>"
        }
      }
    },
    {
      "Sid": "ServiceAccountRoleAssumption",
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/oidc.eks.<AWS_REGION>.amazonaws.com/id/<OIDC_ID>"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.<AWS_REGION>.amazonaws.com/id/<OIDC_ID>:aud": "sts.amazonaws.com",
          "oidc.eks.<AWS_REGION>.amazonaws.com/id/<OIDC_ID>:sub": ["system:serviceaccount:argocd:argocd-application-controller", "system:serviceaccount:argocd:argocd-applicationset-controller", "system:serviceaccount:argocd:argocd-server"]
        }
      }
    }
  ]
}
```

---

## 🧾 2. Annotate Argo CD Service Accounts

Update service accounts with the `eks.amazonaws.com/role-arn` annotation:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argocd-application-controller
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ARGO_CD_MANAGEMENT_IAM_ROLE_NAME>
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argocd-applicationset-controller
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ARGO_CD_MANAGEMENT_IAM_ROLE_NAME>
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argocd-server
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ARGO_CD_MANAGEMENT_IAM_ROLE_NAME>
```

🔄 Restart the related Argo CD pods after updating the service accounts.

---

## 🛡️ 3. Allow Management Role to Assume Cluster Roles

Attach this permission policy to the Argo CD management role:

```json
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": ["arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_CLUSTER_ROLE>"]
  }
}
```

---

## 🔁 4. Create a Role for the Target EKS Cluster

Create an IAM role for each EKS cluster, with the following trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ARGO_CD_MANAGEMENT_IAM_ROLE_NAME>"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

This role needs no IAM policy attached directly.

---

## 🔐 5. Configure EKS Access Entry

Grant access to the EKS cluster:

```bash
aws eks create-access-entry \
  --cluster-name my-eks-cluster-name \
  --principal-arn arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_CLUSTER_ROLE> \
  --type STANDARD \
  --kubernetes-groups []

aws eks associate-access-policy \
  --cluster-name my-eks-cluster-name \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster \
  --principal-arn arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_CLUSTER_ROLE>
```

---

## 📦 6. Add EKS Cluster Secret to Argo CD

Create a Kubernetes Secret with the following format:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mycluster-secret
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: "eks-cluster-name-for-argo"
  server: "https://xxxyyyzzz.xyz.<region>.eks.amazonaws.com"
  config: |
    {
      "awsAuthConfig": {
        "clusterName": "my-eks-cluster-name",
        "roleARN": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_CLUSTER_ROLE>"
      },
      "tlsClientConfig": {
        "insecure": false,
        "caData": "<base64 encoded certificate>"
      }
    }
```

Apply the secret to the namespace where Argo CD is installed:

```bash
kubectl apply -f mycluster-secret.yaml -n argocd
```

---

## ✅ Done!

You have now successfully added an EKS cluster to Argo CD using IRSA and role assumption via `argocd-k8s-auth`.
