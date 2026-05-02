# VPC Endpoint

## Interface endpoint vs Gateway endpoint

| Feature            | Interface Endpoint                                                        | Gateway Endpoint                                              |
| ------------------ | ------------------------------------------------------------------------- | ------------------------------------------------------------- |
| Supported Services | Most AWS services (e.g., SSM, CloudWatch, ECR API, Secrets Manager, etc.) | Only S3 and DynamoDB                                          |
| How it works       | Creates ENI (Elastic Network Interface) in your VPC (private IP)          | Creates a route table entry for the service                   |
| Traffic            | Stays inside AWS network, private IP in your subnet                       | Routes via VPC route table, private AWS network               |
| Cost               | Has data processing charges + hourly per endpoint                         | Free, no hourly cost (but normal data transfer charges apply) |
| Use case           | Private access to most AWS services                                       | Private access to S3 / DynamoDB only                          |
| Cross-region?      | No (regional)                                                             | No (regional)                                                 |
