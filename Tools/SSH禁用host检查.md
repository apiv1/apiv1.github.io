~/.ssh/config
```
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

```bash
mkdir -p ~/.ssh && echo -e "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null" >> ~/.ssh/config
```

```bash
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
```