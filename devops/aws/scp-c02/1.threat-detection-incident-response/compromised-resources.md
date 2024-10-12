# Compromised resources

## EC2 instances

<img src="./assets/compromised-ec2.png" />

### Steps to address

- Capture the instance's metadata
- Enable Termination Protection
- Isolate the instance (replace instance's SG - no outbound traffic allowed)
- Detach the instance from any ASG (Suspend processes)
- Deregister the instnace from any ELB
- Snapshot the EBS volumes (deep analysis)
- Tag the EC2 instance (to mark this instance is compromised)

### Investigation types

- **Offline investigation**: shutdown instance and investigate with the EBS snapshot (by creating a new one from this EBS snapshot)
- **Online investigation**: investigate the compromised instance
