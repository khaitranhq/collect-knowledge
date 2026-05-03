# Attribute-Based Access Control (ABAC) in AWS IAM

Attribute-based access control (ABAC) is an authorization strategy that defines permissions based on attributes (called tags in AWS). ABAC provides a flexible and scalable way to manage access to AWS resources.

## How ABAC Works

With ABAC, you can:

- Attach tags to IAM resources (users or roles) and AWS resources
- Create a small set of policies that use these tags to control access
- Allow operations when the principal's tag matches the resource tag

For example, you can create three IAM roles with the `access-project` tag key but different values:

- Role 1: `access-project = Heart`
- Role 2: `access-project = Star`
- Role 3: `access-project = Lightning`

Then use a single policy that grants access when the IAM role and the resource have matching `access-project` tag values.

## ABAC vs Traditional RBAC (Role-Based Access Control)

### Traditional RBAC in AWS

- Defines permissions based on job functions
- Requires separate policies for each role
- When new resources are added, policies must be updated
- Typically results in maintaining many different policies

![RBAC Model](https://example.com/rbac-diagram.png)

### ABAC Advantages

1. **Scalable permissions:** Administrators don't need to update policies for new resources. If new resources are tagged appropriately, permissions automatically apply.

2. **Fewer policies required:** Instead of creating different policies for different roles, you can use a smaller set of tag-based policies.

3. **Dynamic adaptation:** Teams can respond to growth and change without policy updates. New projects can be added by creating roles with appropriate tags.

4. **Granular permission control:** ABAC enables fine-grained access control based on multiple attributes.

5. **Integration with corporate directories:** You can configure your SAML or OIDC provider to pass session tags from your corporate directory to AWS, allowing permissions to be based on employee attributes.

## Example Scenarios

### Adding New Resources

When the Heart project needs additional EC2 instances:

1. Developer creates instances with `access-project = Heart` tag
2. Team members with the Heart role automatically have access to these instances
3. No policy updates needed

### Team Member Transfers

When a team member moves from Heart to Lightning project:

1. IAM administrator assigns them to the Lightning IAM role
2. The team member immediately gains access to Lightning project resources
3. No permission policy changes required

## Implementation

For a detailed tutorial on implementing ABAC in AWS, refer to the [IAM tutorial: Define permissions to access AWS resources based on tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html).

## Supported Services

Not all AWS services support tag-based authorization. To learn which services work with ABAC, see [AWS services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html).
