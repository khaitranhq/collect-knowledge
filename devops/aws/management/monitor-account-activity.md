# Monitoring AWS Account Activities

This document outlines various methods to monitor and track activities within your AWS account.

## AWS Config Configuration History

- Requires AWS Config Configuration Recorder to be enabled
- Provides detailed configuration history for resources

## CloudTrail Event History

- Search API history for the past 90 days
- Filter capabilities:
  - By resource name
  - By resource type
  - By event name
  - By IAM user
  - By assumed IAM role session name
  - By AWS Access Key

## CloudWatch Logs Insights

- Enables searching API history beyond the 90-day limit
- Requirements:
  - CloudTrail Trail must be configured to send logs to CloudWatch Logs
- Provides advanced query capabilities for log analysis

## Athena Queries

- Allows searching API history beyond the 90-day limit
- SQL-based querying of CloudTrail logs stored in S3
- Useful for complex analysis and reporting
