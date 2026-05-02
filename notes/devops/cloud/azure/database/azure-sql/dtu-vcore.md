# DTU vs vCore in Azure SQL Database

## What is DTU in Azure SQL?

**DTU (Database Transaction Unit)** is a **blended performance metric** that combines CPU, memory, I/O reads, and I/O writes into a single unit of measure. It was designed to provide a simplified way to understand and select database performance tiers without needing to understand individual hardware specifications.

### Key Characteristics of DTU:

- **Bundled Resource Model**: DTU packages compute (CPU/memory) and I/O into a single performance metric
- **Fixed Pricing**: One fixed price includes compute, data storage, and backup retention
- **Preconfigured Tiers**: Available in Basic, Standard, and Premium tiers with predefined performance levels
- **Range**: DTUs range from 5 (Basic tier) to 4,000 (Premium tier)
- **Simplicity**: No need to configure individual compute and storage components separately
- **Hardware Abstraction**: Underlying hardware details (processor type, speed, RAM) are hidden from the user

### DTU Service Tiers:

| Tier         | DTU Range     | Use Case                                                    |
| ------------ | ------------- | ----------------------------------------------------------- |
| **Basic**    | 5 DTUs        | Development, testing, small infrequently accessed databases |
| **Standard** | 10-3000 DTUs  | Small to medium production workloads, web applications      |
| **Premium**  | 125-4000 DTUs | IO-intensive workloads requiring high performance           |

---

## Decision Tree: When to Choose DTU vs vCore

### Choose **DTU** when:

```
✓ Simplicity is a priority
✓ Small to medium workloads
✓ Quick entry without evaluating hardware specifications
✓ Fixed, predictable pricing preferred
✓ No need to scale compute and storage independently
✓ Development, testing, or low-traffic web applications
✓ No Software Assurance or Azure Hybrid Benefit available
✓ Team lacks cloud infrastructure expertise
✓ Workload fits within predefined DTU tier limits
```

**Best for:**

- Getting started with Azure SQL Database quickly
- Applications with predictable, steady workloads
- Teams new to Azure that prefer simplicity over granular control
- Cost-conscious projects needing all-inclusive pricing

---

### Choose **vCore** when:

```
✓ Granular control over CPU and memory required
✓ Need to scale compute and storage independently
✓ Large or variable workloads
✓ Migrating from on-premises SQL Server
✓ Can leverage Azure Hybrid Benefit (with Software Assurance)
✓ Need reserved capacity pricing for cost savings
✓ Require Business Critical or Hyperscale service tiers
✓ Need serverless compute with auto-pause/auto-resume
✓ IO-intensive or performance-sensitive applications
✓ Require specific hardware generations (Gen5, Fsv2, M-series)
✓ Need transparency into underlying hardware specifications
```

**Best for:**

- Enterprise workloads requiring precise resource allocation
- Cost optimization through Azure Hybrid Benefit (up to 55% savings)
- Mission-critical applications needing Business Critical tier
- Dev/Test environments using serverless compute (auto-pause saves costs)
- Workloads requiring >4000 DTU equivalent performance
- Organizations with existing SQL Server licenses and Software Assurance

---

## Quick Decision Matrix

| Factor                   | DTU              | vCore                      |
| ------------------------ | ---------------- | -------------------------- |
| **Complexity**           | Low (bundled)    | High (granular)            |
| **Pricing Model**        | Fixed per tier   | Separate compute + storage |
| **Flexibility**          | Limited          | High                       |
| **Cost Transparency**    | Simple           | Detailed                   |
| **Performance Range**    | 5-4000 DTUs      | Unlimited scaling          |
| **Hardware Visibility**  | Hidden           | Visible                    |
| **Azure Hybrid Benefit** | ❌ Not available | ✅ Available               |
| **Serverless Option**    | ❌ Not available | ✅ Available               |
| **Reserved Instances**   | ❌ Not available | ✅ Available               |
| **Entry Price Point**    | Lower            | Higher                     |
| **Scaling Granularity**  | Tier-based       | Per vCore                  |

---

## Migration Between Models

**Important Notes:**

- You can switch between DTU and vCore models at any time
- The underlying Azure SQL Database service remains the same
- Conversion typically requires brief downtime
- No data migration required; configuration change only

### Approximate DTU to vCore Conversion (Standard Tier):

```
~100 DTUs  ≈ 1 vCore (General Purpose)
~200 DTUs  ≈ 2 vCores (General Purpose)
~400 DTUs  ≈ 4 vCores (General Purpose)
~800 DTUs  ≈ 8 vCores (General Purpose)
```

_Note: Actual performance correlation depends on specific workload characteristics (CPU-bound, IO-bound, memory-bound)._

---

## Summary Recommendation

**Start with DTU if:**

- You're new to Azure SQL Database
- You prefer simplicity and want to get started quickly
- Your workload is small to medium with predictable usage
- You don't have Software Assurance

**Migrate to vCore when:**

- You need more granular control and transparency
- Your workload grows beyond DTU capabilities
- You obtain Software Assurance and can leverage Azure Hybrid Benefit
- You require advanced features (Hyperscale, serverless compute)
- Cost optimization becomes critical at scale
