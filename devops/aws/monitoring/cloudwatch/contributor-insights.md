# CloudWatch Contributor Insights

CloudWatch Contributor Insights helps you analyze log data and create time series that display contributor data. This feature provides valuable insights into system performance and behavior patterns.

## Key Features

- Helps identify top contributors and understand what's impacting system performance
- Supports analysis of any AWS-generated logs (VPC, DNS, etc.)
- Offers both AWS-built rules and custom rule creation capabilities
- Leverages existing CloudWatch Logs

## Common Use Cases

- Identify problematic hosts
- Monitor heaviest network users
- Track URLs generating the most errors
- Analyze system performance bottlenecks

## Example: VPC Flow Logs Analysis

Below is an example of Contributor Insights analyzing VPC Flow Logs:

![contributor-insight-flow-logs](/home/lewis/Workspaces/Personal/collect-knowledge/devops/aws/monitoring/cloudwatch/assets/2025-02-22-21-52-53.png)

## References

- [Create a Contributor Insights rule in CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-CreateRule.html)
- [Contributor Insights rule syntax in CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-RuleSyntax.html)
