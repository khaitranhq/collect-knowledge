# IAM Policy to access a specific EC2 instance with Fleet Manager

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EC2",
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "ec2:GetPasswordData"],
      "Resource": "*"
    },
    {
      "Sid": "SSM",
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeInstanceProperties",
        "ssm:GetCommandInvocation",
        "ssm:GetInventorySchema"
      ],
      "Resource": "*"
    },
    {
      "Sid": "TerminateSession",
      "Effect": "Allow",
      "Action": ["ssm:TerminateSession"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ssm:resourceTag/aws:ssmmessages:session-id": ["${aws:userid}"]
        }
      }
    },
    {
      "Sid": "SSMStartSession",
      "Effect": "Allow",
      "Action": ["ssm:StartSession"],
      "Resource": [
        "arn:aws:ec2:region:account-id:instance/instace-id",
        "arn:aws:ssm:region:account-id:managed-instance/instance-id",
        "arn:aws:ssm:region::document/AWS-StartPortForwardingSession"
      ],
      "Condition": {
        "ForAnyValue:StringEquals": {
          "aws:CalledVia": "ssm-guiconnect.amazonaws.com"
        }
      }
    },
    {
      "Sid": "GuiConnect",
      "Effect": "Allow",
      "Action": [
        "ssm-guiconnect:CancelConnection",
        "ssm-guiconnect:GetConnection",
        "ssm-guiconnect:StartConnection",
        "ssm-guiconnect:ListConnections"
      ],
      "Resource": "*"
    }
  ]
}
```
