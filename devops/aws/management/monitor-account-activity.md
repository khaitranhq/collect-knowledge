# Monitor Account Activities
AWS Config Configuration History
• Must have AWS Config Configuration Recorder on
• CloudTrail Event History
• Search API history for past 90 days
• Filter by resource name, resource type, event name, …
• Filter by IAM user, assumed IAM role session name, or AWS Access Key
• CloudWatch Logs Insights
• Search API history beyond the past 90 days
• CloudTrail Trail must be configured to send logs to CloudWatch Logs
• Athena Queries
• Search API history beyond the past 90 days
