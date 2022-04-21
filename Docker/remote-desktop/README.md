### Build
```bash
```

### Chrome

cli
```bash
docker run --rm -d --network=host -e PASSWORD=${RDP_PASSWD:-pass} -v $PWD/data/home:/home -v /dev/shm:/dev/shmq --privileged ${IMAGE_NAME}
```

docker-compose
```bash
echo "
version: '3.9'
services:
  app:
    image: ${IMAGE_NAME}
    restart: always
    environment:
      USERNAME: user
      PASSWORD: ${RDP_PASSWD}
    privileged: true
    volumes:
      - ./data/home:/home
      - /dev/shm:/dev/shmq
    network_mode: host
" | docker-compose -f -
```