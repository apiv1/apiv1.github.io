#### 部署独立的dockerd服务, 拥有独立ip, 并提供一个可以支持远程docker的sshd服务

可以同时部署多个dockerd服务到不同的局域网内独立ip,充分利用服务器资源.
- - - - - -

先创建macvlan类型的docker network

```shell
# 假定ip段为 192.168.0.0/24, 网关是192.168.0.1, 网络接口eth0
# 使用时需要替换这些变量值为自己的实际情况
SUB_NET=192.168.0.0/24
GATEWAY=192.168.0.1
INTERFACE=eth0
docker network create -d macvlan --subnet=$SUB_NET --gateway=$GATEWAY -o parent=$INTERFACE macvlan-network
```

部署镜像仓库服务```registry```, 减少重复拉取镜像. [部署配置参考这里](../registry/compose.mirror.yml)

```shell
vim compose.yml # registry部署配置
docker compose up -d
```

compose.override.yml

```yml
name: ${COMPOSE_PROJECT_NAME}
services:
  dind:
    networks:
      lan:
        ipv4_address: ${BIND_IP}
    environment:
      - PGID=2000
      - PUID=2000
    configs:
      - source: authorized_keys
        target: /home/${USERNAME:-docker}/.ssh/authorized_keys
      - source: ssh.conf
        target: /etc/ssh/ssh_config.d/ssh.conf
      - source: sshd.conf
        target: /etc/ssh/sshd_config.d/sshd.conf
      - source: docker-daemon.json
        target: /etc/docker/daemon.json
configs:
  authorized_keys:
    content: |
      ${AUTH_KEYS}
  ssh.conf:
    content: |

  sshd.conf:
    content: |
      ListenAddress 0.0.0.0
      Port 22
  docker-daemon.json:
    content: |
      {
        "registry-mirrors": ["http://localhost:5000"],
        "insecure-registries": ["localhost:5000"]
      }

networks:
  lan:
    name: macvlan-network
    external: true
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

# 指定的局域网ip
BIND_IP=
```

- - - - - -
