# CloudWatch agent - procstat plugin

## Overview

The procstat plugin allows you to collect metrics and monitor system utilization of individual processes on your servers.

## Compatibility

- Linux servers
- Windows servers

## Features

- Monitors individual process metrics
- Tracks system resource utilization
- Provides detailed process-level insights

## Metrics Examples

- Process CPU time usage
- Process memory consumption
- Process disk I/O
- Process thread count

## Process Selection Methods

You can select which processes to monitor using any of these methods:

1. **pid_file**

   - Monitor using PID file names
   - Tracks processes by their identification number files

2. **exe**

   - Monitor using process name
   - Supports RegEx pattern matching
   - Example: `java`, `apache2`, `nginx`

3. **pattern**
   - Monitor using command line patterns
   - Supports RegEx for flexible matching
   - Matches against process start commands

## Metric Naming Convention

All metrics collected by the procstat plugin use the "procstat" prefix:

- `procstat_cpu_time`
- `procstat_cpu_usage`
- `procstat_memory_used`
- `procstat_disk_bytes_read`
- And more...

## Best Practices

1. Use specific process selection criteria to avoid monitoring unnecessary processes
2. Monitor only essential metrics to reduce CloudWatch costs
3. Set appropriate collection intervals based on your monitoring needs
