# IAM Policy for Step Functions triggering other Step Functions

Tags: AWS, Step Function
Application: AWS Management

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:events:us-east-2:<AWS ACCOUNT ID>:rule/StepFunctionsGetEventsForBatchJobsRule",
                "arn:aws:events:us-east-2:<AWS ACCOUNT ID>:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"
            ]
        },
        {
            "Action": [
                "batch:SubmitJob",
                "batch:DescribeJobs",
                "batch:TerminateJob",
                "sns:Publish"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "states:StartExecution",
            ],
            "Effect": "Allow",
            "Resource": [
                "<Sfn Execution Arns>"
            ]
        },
        {
            "Action": [
                "states:DescribeExecution",
                "states:StopExecution"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
```
