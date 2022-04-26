```bash
mkdir -p ~/.ssh && echo "
Host *
    ServerAliveInterval  60
    ServerAliveCountMax  60
    ConnectTimeout 30
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
">> ~/.ssh/config
```

```bash
alias ssh="ssh \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=60 \
    -o ConnectTimeout=30 \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    "
```