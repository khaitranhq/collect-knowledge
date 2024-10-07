# Persistence in Redis and ElastiCache

## Persistence in Redis

There are two ways to ensure data persistence in Redis across restarts: through regular database snapshots (**RDB**) or by enabling the append-only file (**AOF**), a log capturing all the performed operations. Both methods, if enabled, will be replayed automatically when your Redis server starts. We can combine both methods.

### Regular snapshots (RDB)

- Can be enabled by configuring save points in `redis.conf` and restart the server

```
# after 900 sec (15 min) if at least 1 key changed
save 900 1

# after 300 sec (5 min) if at least 10 keys changed
save 300 10

# after 60 sec if at least 10000 keys changed
save 60 10000
```

- Verify by command `info persistence` with response be like

```
rdb_changes_since_last_save:2
rdb_bgsave_in_progress:0
rdb_last_save_time:1582116473
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
```

### Append-only file (AOF)

- Can be enabled in `redis.conf` and restart the server

```
appendonly yes
appendfsync always|everysec|no
```

- The `appendfsync` option tells Redis how often it should flush the log file to disk

  - `always`: every new entry (basically every performed operation), will be flushed to disk immediately
  - `everysec`: every second, flushes to disk
  - `no`: leave this up to your operating system

- Verify by command `info persistence` with response be like

```
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
aof_current_size:88
aof_base_size:88
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0
```

## What happens when Redis runs out of memory?

- When pushing new values to Redis with limited memory, data handling depends on the `maxmemory-policy` setting.
- `maxmemory-policy` Setting: Determines the behavior when Redis runs out of memory:

  - `noeviction`: New values aren’t saved when memory limit is reached. When a database uses replication, this applies to the primary database
  - `allkeys-lru`: Keeps most recently used keys; removes least recently used (LRU) keys
  - `allkeys-lfu`: Keeps frequently used keys; removes least frequently used (LFU) keys
  - `volatile-lru`: Removes least recently used keys with the expire field set to true.
  - `volatile-lfu`: Removes least frequently used keys with the expire field set to true.
  - `allkeys-random`: Randomly removes keys to make space for the new data added.
  - `volatile-random`: Randomly removes keys with expire field set to true.
  - `volatile-ttl`: Removes keys with expire field set to true and the shortest remaining time-to-live (TTL) value.

## Persistence in ElastiCache

Persistence in AWS ElastiCache Redis clusters is a more complicated story. Let's check some solutions

- Enabling **daily backup**
- Can enable append-only file (**AOF**) but with some limitations
  - AOF is not supported on Redis 2.8.22 and later
  - AOF is not supported for cache.t1, cache.t2 or cache.t3 instances
  - AOF is not supported on Multi-AZ replication groups
- Using Multi-AZ but with a high cost

In conclusion, the solution I’d recommend in order to keep your AWS ElastiCache Redis data as persistent as possible would be:

- Opting for a Multi-AZ auto-failover system with at least 2 nodes.
- Enabling daily backups with as much retention as needed.
- Setting the `maxmemory-policy` directive to `noeviction` inside your ElastiCache parameter group. (? depends on usecase)
