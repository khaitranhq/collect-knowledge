# GuardDuty

## Overview

<img src="./guardduty.png" />

- Input data includes
  - CloudTrail events logs: management events and S3 data events
  - VPC Flow logs
  - DNS logs
  - Optional Features: EKS Audit logs, RDS, Audrora, EBS, Lambda,...
- Integrate EventBridge rules to be notified
- Can protect against **CryptoCurrency** attacks (has a dedicated "finding" for it)

## Multi-account management

<img src="./guardduty_advanced.png" />

- Ability to manage multiple accounts in GuardDuty
- Associate the Member accounts with the Accounts Administrator by 2 ways
  - Through an AWS Organization
  - Sending invitation through GuardDuty
- Administrator account can
  - Add and remove member accounts
  - Manage GuardDuty within the Associated member accounts
  - Manage findings, suppression rules, trusted IP lists, thread lists
- Ability of specifying a member account as the Organization's delegated administrator of GuardDuty

## Some architectures

<img src="./guardduty-example-1.png" />
<img src="./guardduty-example-2.png" />
