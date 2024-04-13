#### 部署一个可以支持远程docker的sshd服务, 使用宿主机dockerd

- - - - - -
compose.override.yml

```yml
name: ${COMPOSE_PROJECT_NAME}
services:
  dood:
    configs:
      - source: authorized_keys
        target: /home/${USERNAME:-docker}/.ssh/authorized_keys
      - source: ssh.conf
        target: /etc/ssh/ssh_config.d/ssh.conf
      - source: sshd.conf
        target: /etc/ssh/sshd_config.d/sshd.conf
    environment:
      - PUID=2000
      - PGID=2000
configs:
  authorized_keys:
    content: |
      ${AUTHORIZED_KEYS}

  ssh.conf:
    content: |

  sshd.conf:
    content: |
      ListenAddress 0.0.0.0
      Port 22
```

.env

```shell
# 指定项目名称,不要和别的compose项目冲突
COMPOSE_PROJECT_NAME=''

# ssh-keygen 生成的公钥放这里
AUTHORIZED_KEYS='
  <secrets>
  <secrets>
  <secrets>
'
```

- - - - - -
