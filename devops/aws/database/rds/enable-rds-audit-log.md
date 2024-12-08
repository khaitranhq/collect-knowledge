# Enable audit log

## References

- {https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html#associate-cmk}[Encrypt log data in CloudWatch Logs using AWS Key Management Service]
- {https://aws.amazon.com/blogs/database/configuring-an-audit-log-to-capture-database-activities-for-amazon-rds-for-mysql-and-amazon-aurora-with-mysql-compatibility/}[Turning on the MariaDB audit plugin for Amazon RDS for MySQL]

## Steps

### Create option group

- On the Amazon RDS console, choose #Option groups#.
- Choose Create option group.
- For Name, enter a name.
- For Description, enter a description.
- For Engine, choose mysql.
- For Major Engine Version, choose your engine version 8.
- Choose Create.
- On the Option groups page, select your option group and choose Add option
- For Option name, choose `MARIADB_AUDIT_PLUGIN`
- Leave the default values
- For Apply immediately, select Yes.
- Choose Add option.
- Update RDS instance with the new option group

### Associate KMS

- Create a KMS key
- Setup policy of the KMS key

```json
{
    "Effect": "Allow",
    "Principal": {
        "Service": "logs.<region>.amazonaws.com"
    },
    "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
    ],
    "Resource": "*",
    "Condition": {
        "ArnLike": {
          "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:<region>:<account-id>:#8
        }
    }
}
```

- Associate it to the log group

```bash
aws logs associate-kms-key --log-group-name "log group name" --kms-key-id "key-arn"
```
