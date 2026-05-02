# CloudWatch Investigation

## Types of Items That Can Be Surfaced

- **Hypotheses about root causes**
- **CloudWatch alarms** (including both metric alarms and composite alarms)
- **CloudWatch metrics**
- **AWS Health events**
- **Change events logged in CloudTrail**
- **X-Ray trace data**
- **CloudWatch Logs Insights queries** (for log groups in the Standard log class)
- **CloudWatch Contributor Insights data**
- **CloudWatch Application Signals data**

---

## Ways to Create an Investigation

- **From AWS consoles:**  
  Start an investigation when viewing a CloudWatch metric or alarm in the CloudWatch console, or from a Lambda function's Monitor tab on its properties page.

- **Via Amazon Q chat:**  
  Start by asking questions like "Why is my Lambda function slow today?" or "What's wrong with my database?"

- **Automatically via alarm action:**  
  Configure a CloudWatch alarm action to automatically start an investigation when the alarm goes into ALARM state.

---

## Limitations

- Each account may have up to **2 concurrent investigations** (only those with active analysis count towards this limit).
- Each month, each account may create up to **150 investigations with AI analysis**.

---

## Cost

CloudWatch investigations may incur AWS service usage, including telemetry, resource queries, and other API usage:

- **CloudWatch APIs:**  
  `ListMetrics`, `GetDashboard`, `ListDashboards`, `GetInsightRuleReport`
- **X-Ray APIs:**  
  `GetServiceGraph`, `GetTraceSummaries`, `BatchGetTraces`
- **AWS Cloud Control APIs:**  
  May incur usage of services such as Amazon Kinesis Data Streams and AWS Lambda.
- **Integration with chat applications:**  
  May incur usage of Amazon Simple Notification Service (SNS).

---

## Best Practices to Enhance Investigations

### CloudWatch Agent

- Install the latest version of the CloudWatch agent on your servers.
- Using a recent version enhances the ability to find issues in Amazon EC2 and Amazon EBS during investigations.
- **Minimum recommended version:** 1.300049.1 or later.

### AWS CloudTrail

- Enable CloudTrail, including trails in your investigations.
- CloudTrail records events about changes in your system, including deployment events.
- These events can help CloudWatch investigations create hypotheses about root causes.

### CloudWatch Application Signals

- Application Signals discovers the topology of your environment, including applications and their dependencies.
- Automatically collects standard metrics such as latency and availability.
- Enabling Application Signals allows CloudWatch investigations to use this topology and metric information.

  _For more information, see [Application Signals](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/appsignals.html)._

### X-Ray

- Enable AWS X-Ray to collect traces about requests your applications serve.
- For any traced request, you can see detailed information about the request, response, and calls to downstream AWS resources, microservices, databases, and web APIs.
- This information can help CloudWatch investigations.

  _For more information, see [What is AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)._

### Container Insights

- If you use Amazon ECS or Amazon EKS, install Container Insights.
- This improves the ability of CloudWatch investigations to find issues in your containers.
