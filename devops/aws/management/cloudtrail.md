# CloudTrail

## Notes

- CloudTrail is not "real-time"
- Delivers an envent within 15 minutes of an API call
- Delivers log files to an S3 bucket every 5 minutes

## Log File Integrity Validation

### Digest files

![](/home/lewis/Workspaces/1.Personal/collect-knowledge/assets/2025-02-28-21-25-15.png)

- References the log files for the last hour and contains a hash of each
- Stored in the same S3 bucket as log files (different folder)
- Enable:
  - Console: To enable log file integrity validation with the CloudTrail console, choose Yes for the Enable log file validation option when you create or update a trail
  - To enable log file integrity validation with the AWS CLI, use the --enable-log-file-validation option with the create-trail or update-trail commands. To disable log file integrity validation, use the --no-enable-log-file-validation option
  - To enable log file integrity validation with the CloudTrail API, set the EnableLogFileValidation request parameter to true when calling CreateTrail or UpdateTrail.

### Other methods

- Protect the S3 bucket using bucket policy, versioning,MFA Delete protection, encryption, object lock
- Protect CloudTrail using IAM
