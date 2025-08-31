# Kubernetes Networking & Network Policy Addons: Cilium vs Calico

## Overview

- Kubernetes networking addons extend default networking and security capabilities.
- Popular options: Cilium and Calico.
- Both provide support for Kubernetes NetworkPolicy and cluster-wide security.

---

## Cilium

- Uses eBPF for high-performance networking, observability, and security.
- Provides Layer 3/4/7 network policies (application-aware).
- Built-in observability with Hubble: flow, DNS, HTTP metrics.
- Supports service mesh integration (Envoy).
- Transparent encryption and identity-aware access.
- Works on bare metal, cloud, hybrid, IPv4/IPv6, dual-stack.
- CNCF graduated project.

---

## Calico

- Uses Linux kernel (iptables, eBPF) for networking and security.
- Supports multiple data planes: Linux, eBPF, Windows.
- Provides Layer 3/4 network policies.
- Mature, simple to deploy and operate.
- Supports Kubernetes and non-Kubernetes workloads (VMs, bare metal).
- Windows support.
- CNCF incubating project.

---

## Advantages

### Cilium

- High performance and scalability (eBPF-based).
- Deep observability and monitoring (Hubble).
- Advanced Layer 7 policies.
- Service mesh features.
- Future-proof for cloud-native workloads.

### Calico

- Simple, stable, and widely adopted.
- Flexible policy model: namespace, host, cluster-wide.
- Supports large clusters and non-Kubernetes workloads.
- Multiple data plane options.

---

## Drawbacks

### Cilium

- More complex, advanced features require learning curve.
- Debugging eBPF issues can be challenging.
- Windows support is experimental.
- Slightly higher resource usage.

### Calico

- iptables mode can be slower in very large clusters.
- eBPF mode is newer, less feature-rich than Cilium.
- No built-in service mesh features.
- Less advanced observability.

---

## Use Cases

- Use **Cilium** for:
  - Deep observability, advanced security, service mesh, high performance.
  - Environments supporting eBPF (Linux kernel ≥ 4.9).
- Use **Calico** for:
  - Stability, simplicity, broad compatibility (Windows, non-K8s workloads).
  - Large clusters with basic L3/L4 policy needs.

---

## Official Documentation

- [Cilium Documentation](https://docs.cilium.io/en/stable/)
- [Calico Documentation](https://docs.projectcalico.org/)
- [Cilium Hubble](https://docs.cilium.io/en/stable/gettingstarted/hubble/)
- [Calico eBPF Data Plane](https://docs.projectcalico.org/reference/ebpf/)
