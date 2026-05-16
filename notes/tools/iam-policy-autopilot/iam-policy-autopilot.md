# IAM Policy Autopilot

> Source: [awslabs/iam-policy-autopilot README](https://github.com/awslabs/iam-policy-autopilot/blob/main/README.md)

## Overview

IAM Policy Autopilot is an open-source **Model Context Protocol (MCP) server** and **command-line tool** that analyzes local application code and generates baseline **IAM identity-based policies**.

It is meant to help AI coding assistants produce starting IAM policies faster, so developers can refine them instead of writing policies from scratch.

## What It Is Good For

| Use case | What it helps with |
| --- | --- |
| Policy bootstrap | Create a first-pass IAM policy from source code |
| AccessDenied debugging | Analyze permission errors and suggest policy changes |
| AI-assisted development | Let coding assistants request IAM policy help through MCP |
| AWS app support | Infer permissions from SDK calls in app code |

## Why Use It

- Fast: generates baseline IAM policies quickly.
- Reliable: uses deterministic code analysis.
- Up to date: tracks newer AWS service permissions.

## Supported Languages

| Language | SDK |
| --- | --- |
| Go | AWS SDK for Go v2 |
| Java | AWS SDK for Java v2 |
| JavaScript | AWS SDK for JavaScript v3 |
| TypeScript | AWS SDK for JavaScript v3 |
| Python | Boto3, Botocore |

## CLI Usage

### Install

- Recommended: `uvx iam-policy-autopilot`
- Alternative: `pip install iam-policy-autopilot`
- Direct install script is also available for macOS/Linux

### Main Commands

| Command | Purpose | Example |
| --- | --- | --- |
| `generate-policies` | Generate IAM policy documents from source files | `iam-policy-autopilot generate-policies ./src/app.py --region us-east-1 --account 123456789012 --pretty` |
| `fix-access-denied` | Analyze an AccessDenied message and propose/apply policy changes | `iam-policy-autopilot fix-access-denied "User: ... is not authorized to perform: s3:GetObject on resource: ..."` |
| `mcp-server` | Start the MCP server locally | `iam-policy-autopilot mcp-server --transport http` |

### Useful CLI Flags

- `--service-hints` limits analysis to services your app actually uses.
- `--pretty` formats JSON output.
- `--upload-policies` uploads generated policies to IAM with a prefix.
- `--yes` auto-applies policy changes for `fix-access-denied`.
- `--transport` sets MCP transport to `stdio` or `http`.

## MCP Usage

### What MCP Does

The MCP server lets an AI coding assistant call IAM Policy Autopilot as a tool. The assistant can then generate or refine IAM policies using code context from your project.

### Basic Setup

Run the server:

```bash
iam-policy-autopilot mcp-server
```

Or with HTTP transport:

```bash
iam-policy-autopilot mcp-server --transport http
```

### Example MCP Client Config

```json
{
  "mcpServers": {
    "iam-policy-autopilot": {
      "command": "uvx",
      "args": ["iam-policy-autopilot", "mcp-server"],
      "env": {
        "AWS_PROFILE": "your-profile-name",
        "AWS_REGION": "us-east-1"
      }
    }
  }
}
```

If installed with `pip`, use `"command": "iam-policy-autopilot"` instead of `uvx`.

## Important Notes

- Generates **identity-based** policies only.
- Does **not** support resource-based policies like S3 bucket policies or KMS key policies.
- Does **not** cover SCPs, RCPs, or permission boundaries.
- Generated policies are a starting point. Review and refine before deployment.
- Use `--service-hints` to reduce noisy permissions when you know which AWS services are in use.

## Quick Take

Use IAM Policy Autopilot when you want an AI-friendly way to turn app code or an AccessDenied error into a solid first IAM policy, then clean it up before shipping.
