# ☁️ AWS CDK Custom Resources

## 🔧 AWSCustomResource

📚 **Documentation:** [AWS CDK API Reference](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.custom_resources.AwsCustomResource.html)

The `AWSCustomResource` construct enables you to interact with AWS APIs directly from your CloudFormation templates. It provides a powerful way to:

- 🔄 Execute AWS SDK calls during stack deployment
- 🌉 Bridge gaps in native CloudFormation resource coverage
- ⚡ Perform custom AWS API operations during resource lifecycle events

### Key Features:

- Automatically creates a singleton Lambda function to handle API calls
- Supports CREATE, UPDATE, and DELETE lifecycle events
- Allows precise control over AWS SDK operations
- Handles API response data for use in other constructs

### When to Use:

- Accessing AWS services not yet supported by CloudFormation
- Performing complex API operations during deployment
- Fetching dynamic values from AWS services

**Example:**

```typescript
const getParameter = new cr.AwsCustomResource(this, "GetParameter", {
  onUpdate: {
    // will also be called for a CREATE event
    service: "SSM",
    action: "GetParameter",
    parameters: {
      Name: "my-parameter",
      WithDecryption: true,
    },
    physicalResourceId: cr.PhysicalResourceId.of(Date.now().toString()), // Update physical id to always fetch the latest version
  },
  policy: cr.AwsCustomResourcePolicy.fromSdkCalls({
    resources: cr.AwsCustomResourcePolicy.ANY_RESOURCE,
  }),
});

// Use the value in another construct with
getParameter.getResponseField("Parameter.Value");
```

## ⚙️ Provider

📚 **Documentation:** [AWS CDK API Reference](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.custom_resources.Provider.html)

The `Provider` construct creates a framework for implementing custom CloudFormation resources. It enables you to:

### Purpose

- 🎯 Define custom provisioning logic for CloudFormation stacks
- 🔄 Handle resource lifecycle events (Create, Update, Delete)
- 🛠️ Implement complex workflows beyond native CloudFormation capabilities

### Key Capabilities

- Creates a Lambda-backed custom resource provider
- Manages the complete lifecycle of custom resources
- Supports asynchronous operations with built-in timeout handling
- Provides proper error handling and rollback support

### Best Practices

- Keep handler logic focused and stateless
- Return consistent physical resource IDs
- Implement proper error handling
- Consider using TypeScript for type safety

### When to Use Provider

Use the Provider construct when you need to:

1. 🏗️ **Custom Infrastructure Management**

   - Manage non-AWS resources (e.g., GitHub repositories, external APIs)
   - Implement custom cleanup logic during resource deletion
   - Handle resources with complex lifecycle requirements

2. 🔄 **Complex State Management**

   - Maintain state between resource operations
   - Implement custom rollback behaviors
   - Handle asynchronous resource provisioning

3. 🎯 **Specific Use Cases**

   - Integration with third-party services
   - Custom validation or transformation of resource properties
   - Implementation of domain-specific resource types

4. 🔍 **Advanced Scenarios**
   - When AwsCustomResource is insufficient (non-AWS SDK calls needed)
   - Need for custom error handling and retry logic
   - Requirement for complex resource property validation

**Example:**

```typescript
// 🔨 Create custom resource handler entrypoint
const handler = new lambda.Function(this, "my-handler", {
  runtime: lambda.Runtime.NODEJS_20_X,
  handler: "index.handler",
  code: lambda.Code.fromInline(`
  exports.handler = async (event, context) => {
    return {
      PhysicalResourceId: '1234',
      NoEcho: true,
      Data: {
        mySecret: 'secret-value',
        hello: 'world',
        ghToken: 'gho_xxxxxxx',
      },
    };
  };`),
});

// 🏗️ Provision a custom resource provider framework
const provider = new cr.Provider(this, "my-provider", {
  onEventHandler: handler,
});

new CustomResource(this, "my-cr", {
  serviceToken: provider.serviceToken,
});
```

## ⏳ WaiterStateMachine

📚 **Documentation:** [AWS CDK API Reference](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.custom_resources.WaiterStateMachine.html)

The `WaiterStateMachine` is a specialized Step Functions state machine designed for the custom resource provider framework. It helps you:

### Purpose

- 🔄 Poll for completion of long-running operations
- ⌛ Implement custom waiting logic with retries
- 🎯 Handle timeouts gracefully in resource operations

### Key Features

- Configurable retry intervals and backoff rates
- Custom completion check logic via Lambda
- Timeout handling capabilities
- Optional CloudWatch logging integration
- Built-in error handling and recovery

### Configuration Options

- `interval`: Time between retry attempts
- `maxAttempts`: Maximum number of retry attempts
- `backoffRate`: Rate of exponential backoff
- `isCompleteHandler`: Lambda function to check completion
- `timeoutHandler`: Lambda function for timeout handling
- `logOptions`: Customizable logging settings

**Example:**

````typescript
// The code below shows an example of how to instantiate this type.
// The values are placeholders you should change.
import * as cdk from 'aws-cdk-lib';
import { aws_lambda as lambda } from 'aws-cdk-lib';
import { aws_logs as logs } from 'aws-cdk-lib';
import { aws_stepfunctions as stepfunctions } from 'aws-cdk-lib';
import { custom_resources } from 'aws-cdk-lib';

declare const function_: lambda.Function;
declare const logGroup: logs.LogGroup;
const waiterStateMachine = new custom_resources.WaiterStateMachine(this, 'MyWaiterStateMachine', {
  backoffRate: 123,
  interval: cdk.Duration.minutes(30),
  isCompleteHandler: function_,
  maxAttempts: 123,
  timeoutHandler: function_,

  // the properties below are optional
  disableLogging: false,
  logOptions: {
    destination: logGroup,
    includeExecutionData: false,
    level: stepfunctions.LogLevel.OFF,
  },
});
```
````
