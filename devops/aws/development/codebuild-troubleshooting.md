# AWS CodeBuild Troubleshooting Guide

## Common Issues and Solutions

### 1. Arrays Not Preserved Between Commands

**Issue Description:**

- Arrays defined in one command are not accessible in subsequent commands
- Variable persistence issues between build phases

**Root Cause:**

- Arrays are not natively supported in buildspec commands
- Each command runs in a separate shell instance

**Solutions: Use Script Files:**

```bash
# my-build-script.sh
#!/bin/bash
my_array=(item1 item2 item3)
for item in "${my_array[@]}"; do
    echo "Processing $item"
done
```

```yaml
# buildspec.yml
version: 0.2
phases:
  build:
    commands:
      - chmod +x my-build-script.sh
      - ./my-build-script.sh
```

### Best Practices

1. **Script Organization:**

   - Keep complex logic in separate script files
   - Use shell scripts for array operations
   - Maintain script versioning

2. **Environment Variables:**

   - Use environment variables for simple data sharing
   - Consider using SSM Parameter Store for sensitive data
   - Document all environment variables

3. **Error Handling:**
   - Include error checking in scripts
   - Set appropriate exit codes
   - Log important operations

### Additional Tips

1. **Debugging:**

   - Use `set -x` in shell scripts for verbose output
   - Check CodeBuild logs for execution details
   - Test scripts locally before deployment

2. **Performance:**

   - Minimize script complexity
   - Use efficient data structures
   - Consider caching when appropriate

3. **Security:**
   - Don't hardcode sensitive data
   - Use AWS Secrets Manager for credentials
   - Follow principle of least privilege
