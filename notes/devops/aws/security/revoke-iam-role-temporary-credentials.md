# Revoking IAM Role Temporary Credentials

## Overview

When IAM role temporary credentials are compromised, you need to revoke them immediately. This document explains how to do this effectively.

## Key Points

- Users typically have long session durations (e.g., 12 hours)
- If credentials are exposed, they can be used for the entire session duration
- You can immediately revoke permissions for credentials issued before a specific time
- AWS handles this by attaching an inline IAM policy to the role that denies all permissions for older tokens
- This forces users with older tokens to reauthenticate
- Users who assume the role after you revoke sessions are not affected (no need to delete the policy)

## Implementation

To revoke temporary credentials, attach the following inline IAM policy to the role:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ],
            "Condition": {
                "DateLessThan": {
                    "aws:TokenIssueTime": "[policy creation time]"
                }
            }
        }
    ]
}
```

Replace `[policy creation time]` with the current timestamp when you create the policy.
