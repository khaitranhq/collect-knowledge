# OpenSearch

## Permission for `_cat/indices`

```json
{
  "cluster_permissions": ["cluster:monitor/state", "cluster:monitor/health"],
  "index_permissions": [
    {
      "index_patterns": ["#"],
      "allowed_actions": [
        "indices:monitor/settings/get",
        "indices:monitor/settings/get",
        "indices:monitor/stats"
      ]
    }
  ]
}
```
