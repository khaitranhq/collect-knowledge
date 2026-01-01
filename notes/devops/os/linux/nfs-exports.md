# NFS Configuration

## Confiuguring location

`/etc/exports` is the file where NFS exports are configured. Each line in this file defines a directory to be shared and the access permissions for clients.

Format

```
<directory> <client1>(<options>) <client2>(<options>) ...
```

Example

```
/home/shared 192.168.1.5(rw,sync,no_subtree_check)
/var/nfs *(rw,sync,no_root_squash)

```

## Options

- `rw`: Read and write access.
- `ro`: Read-only access.
- `sync`: Ensures changes are written to disk before the server responds.
- `async`: Allows the server to respond before changes are written to disk (faster but less safe).
- `no_subtree_check`: Disables subtree checking for better performance.
- `root_squash`: Maps requests from root on the client to the anonymous user on the server.
- `no_root_squash`: Allows root on the client to have root access
- `all_squash`: Maps all client requests to the anonymous user.
- `anonuid` and `anongid`: Specify the UID and GID for the anonymous user.

## Applying Changes

```bash
sudo exportfs -a
```
