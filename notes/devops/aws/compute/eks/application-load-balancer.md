# Route application and HTTP traffic from EKS clusters with Application Load Balancers

## Prerequisites

### Cluster and Controller

- Have an existing cluster.
- Have the AWS Load Balancer Controller deployed on your cluster. For more information, see [Route internet traffic with AWS Load Balancer Controller](./install-aws-load-balancer-controller.md). We recommend version 2.7.2 or later.

### Subnets

- At least two subnets in different Availability Zones. The AWS Load Balancer Controller chooses one subnet from each Availability Zone. When multiple tagged subnets are found in an Availability Zone, the controller chooses the subnet whose subnet ID comes first lexicographically. Each subnet must have at least eight available IP addresses.

### Security Groups

- If you’re using multiple security groups attached to worker nodes, exactly one security group must be tagged as follows. Replace `<my-cluster>` with your cluster name.

  ```
  Key – kubernetes.io/cluster/<my-cluster>
  Value – shared or owned
  ```

### Subnet Tagging

- If you’re using the AWS Load Balancer Controller version 2.1.1 or earlier, subnets must be tagged in the format that follows. If you’re using version 2.1.2 or later, tagging is optional. However, we recommend that you tag a subnet if any of the following is the case:

  - You have multiple clusters running in the same VPC.
  - You have multiple AWS services that share subnets in a VPC.
  - You want more control over where load balancers are provisioned for each cluster. Replace `<my-cluster>` with your cluster name.

  ```
  Key – kubernetes.io/cluster/<my-cluster>
  Value – shared or owned
  ```

### Public and Private Subnets

- Your public and private subnets must meet the following requirements unless you explicitly specify subnet IDs as an annotation on a service or ingress object. Assume that you provision load balancers by explicitly specifying subnet IDs as an annotation on a service or ingress object. In this situation, Kubernetes and the AWS load balancer controller use those subnets directly to create the load balancer and the following tags aren’t required.

  - **Private subnets** – Must be tagged in the following format. This is so that Kubernetes and the AWS load balancer controller know that the subnets can be used for internal load balancers. If you use `eksctl` or an Amazon EKS AWS CloudFormation template to create your VPC after March 26, 2020, the subnets are tagged appropriately when created. For more information about the Amazon EKS AWS CloudFormation VPC templates, see Create an Amazon VPC for your Amazon EKS cluster.

    ```
    Key – kubernetes.io/role/internal-elb
    Value – 1
    ```

  - **Public subnets** – Must be tagged in the following format. This is so that Kubernetes knows to use only the subnets that were specified for external load balancers. This way, Kubernetes doesn’t choose a public subnet in each Availability Zone (lexicographically based on their subnet ID). If you use `eksctl` or an Amazon EKS AWS CloudFormation template to create your VPC after March 26, 2020, the subnets are tagged appropriately when created. For more information about the Amazon EKS AWS CloudFormation VPC templates, see Create an Amazon VPC for your Amazon EKS cluster.

    ```
    Key – kubernetes.io/role/elb
    Value – 1
    ```

- If the subnet role tags aren’t explicitly added, the Kubernetes service controller examines the route table of your cluster VPC subnets to determine if the subnet is private or public. We recommend that you don’t rely on this behavior. Rather, explicitly add the private or public role tags. The AWS Load Balancer Controller doesn’t examine route tables. It also requires the private and public tags to be present for successful auto discovery.

### Ingress Resource

- The AWS Load Balancer Controller creates ALBs and the necessary supporting AWS resources whenever a Kubernetes ingress resource is created on the cluster with the `kubernetes.io/ingress.class: alb` annotation. The ingress resource configures the ALB to route HTTP or HTTPS traffic to different Pods within the cluster. To ensure that your ingress objects use the AWS Load Balancer Controller, add the following annotation to your Kubernetes ingress specification. For more information, see Ingress specification on GitHub.

  ```
  annotations:
  kubernetes.io/ingress.class: alb
  ```

  > **Note**: If you’re load balancing to IPv6 Pods, add the following annotation to your ingress spec. You can only load balance over IPv6 to IP targets, not instance targets. Without this annotation, load balancing is over IPv4.

  ```
  alb.ingress.kubernetes.io/ip-address-type: dualstack
  ```

### Traffic Modes

- The AWS Load Balancer Controller supports the following traffic modes:

  - **Instance** – Registers nodes within your cluster as targets for the ALB. Traffic reaching the ALB is routed to NodePort for your service and then proxied to your Pods. This is the default traffic mode. You can also explicitly specify it with the `alb.ingress.kubernetes.io/target-type: instance` annotation.

    > **Note**: Your Kubernetes service must specify the NodePort or "LoadBalancer" type to use this traffic mode.

  - **IP** – Registers Pods as targets for the ALB. Traffic reaching the ALB is directly routed to Pods for your service. You must specify the `alb.ingress.kubernetes.io/target-type: ip` annotation to use this traffic mode. The IP target type is required when target Pods are running on Fargate or Amazon EKS Hybrid Nodes.

### Tagging ALBs

- To tag ALBs created by the controller, add the following annotation to the controller: `alb.ingress.kubernetes.io/tags`. For a list of all available annotations supported by the AWS Load Balancer Controller, see Ingress annotations on GitHub.

### Version Upgrades

- Upgrading or downgrading the ALB controller version can introduce breaking changes for features that rely on it. For more information about the breaking changes that are introduced in each release, see the ALB controller release notes on GitHub.
