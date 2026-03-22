# Connect to your EKS cluster using kubectl

To connect to your EKS cluster using kubectl, you need to follow these steps:

1. Update kubeconfig with the following command:

```bash
aws eks --region <region-code> update-kubeconfig --name <cluster-name>
```

Replace `<region-code>` with the AWS region where your EKS cluster is located and `<cluster-name>` with the name of your EKS cluster.

2. Verify the connection to your EKS cluster by running:

```bash
kubectl get svc
```

This command will list the services running in your EKS cluster. If you see the services listed
