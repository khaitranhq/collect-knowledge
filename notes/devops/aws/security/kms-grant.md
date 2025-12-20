# AWS KMS Grants

## What is a KMS Grant?

A **KMS Grant** is a temporary, token-based authorization mechanism that allows AWS principals to use KMS keys for cryptographic operations **without modifying key policies or IAM policies**.

### Key Differences from Policies

| Aspect       | KMS Grants                          | Key/IAM Policies              |
| ------------ | ----------------------------------- | ----------------------------- |
| Format       | API-based tokens                    | JSON documents                |
| Lifecycle    | Temporary, programmatically managed | Permanent until changed       |
| Primary Use  | Service-to-service delegation       | Human users, long-term access |
| Modification | Simple API calls                    | Policy editing required       |

---

## How Grants Work

```
┌─────────────┐                    ┌──────────────┐
│   Service   │                    │   KMS Key    │
│  (Grantee)  │                    │              │
└──────┬──────┘                    └──────┬───────┘
       │                                  │
       │  1. CreateGrant                  │
       │  ───────────────────────────────>│
       │                                  │
       │  2. Grant Token + Grant ID       │
       │  <───────────────────────────────│
       │                                  │
       │  3. Encrypt/Decrypt              │
       │     (using Grant Token)          │
       │  ───────────────────────────────>│
       │                                  │
       │  4. Operation Result             │
       │  <───────────────────────────────│
       │                                  │
       │  5. RetireGrant/RevokeGrant      │
       │  ───────────────────────────────>│
       └──────────────────────────────────┘
```

---

## Common Usage Scenarios

### 1. **EBS Volume Encryption**

```bash
# AWS automatically creates grants when attaching encrypted EBS volumes
# Allows EC2 to: GenerateDataKey, Decrypt, CreateGrant
```

### 2. **S3 Server-Side Encryption (SSE-KMS)**

```bash
# S3 receives grant to encrypt/decrypt objects
# Operations: GenerateDataKey, Decrypt
```

### 3. **RDS Database Encryption**

```bash
# RDS service gets grant to encrypt database storage
# Operations: GenerateDataKey, Decrypt, CreateGrant
```

### 4. **Lambda Environment Variables**

```bash
# Grant Lambda to decrypt environment variables
aws kms create-grant \
  --key-id arn:aws:kms:us-east-1:123456789012:key/abc-123 \
  --grantee-principal arn:aws:iam::123456789012:role/lambda-role \
  --operations Decrypt
```

---

## Grant Operations

### Create Grant

```bash
aws kms create-grant \
  --key-id <key-id> \
  --grantee-principal <principal-arn> \
  --operations Decrypt GenerateDataKey
```

### List Grants

```bash
aws kms list-grants --key-id <key-id>
```

### Retire Grant (by grantee)

```bash
aws kms retire-grant --grant-id <grant-id>
```

### Revoke Grant (by key admin)

```bash
aws kms revoke-grant --key-id <key-id> --grant-id <grant-id>
```

---

## Grant Permissions

| Permission        | Purpose                                           |
| ----------------- | ------------------------------------------------- |
| `Encrypt`         | Encrypt data with KMS key                         |
| `Decrypt`         | Decrypt ciphertext                                |
| `GenerateDataKey` | Create data encryption keys (envelope encryption) |
| `CreateGrant`     | Allow grantee to create sub-grants                |
| `RetireGrant`     | Retire the grant                                  |

---

## When to Use Grants

✅ **Use Grants For:**

- AWS service integrations (EBS, RDS, S3, Lambda)
- Temporary delegations
- Automated workflows requiring frequent permission changes
- Service-to-service encryption

❌ **Use IAM/Key Policies For:**

- Human user access
- Long-term, static permissions
- Complex conditional logic

---

## Grant Constraints (Security)

```bash
# Add encryption context constraint
aws kms create-grant \
  --key-id <key-id> \
  --grantee-principal <principal> \
  --operations Decrypt \
  --constraints EncryptionContextSubset={Environment=Production}
```

**Purpose**: Limits grant usage to operations with matching encryption context

---

## Best Practices

1. **Let AWS services manage grants automatically** (EBS, RDS, S3)
2. **Always use encryption context constraints** for security
3. **Audit grants regularly**: `aws kms list-grants`
4. **Follow least privilege**: Grant only required operations
5. **Retire grants** when no longer needed

---

## Quick Reference

```bash
# Create
aws kms create-grant --key-id <key> --grantee-principal <arn> --operations Decrypt

# List
aws kms list-grants --key-id <key>

# Retire (as grantee)
aws kms retire-grant --grant-id <id>

# Revoke (as admin)
aws kms revoke-grant --key-id <key> --grant-id <id>
```

---

## Summary

**KMS Grants** = Temporary, token-based permissions for services to use KMS keys

- **Created programmatically** via API
- **Ideal for AWS service integrations** and temporary access
- **More flexible** than policy modifications for dynamic scenarios
- **Revocable** at any time
