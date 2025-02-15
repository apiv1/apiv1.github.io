生成dsa密钥对
```shell
openssl dsaparam -out dsa_params.pem 1024
openssl genpkey -paramfile dsa_params.pem -out dsa_private.key
openssl dsa -in dsa_private.key -pubout -out dsa_public.key
```

一句话命令
```shell
openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout selfsigned.key -out selfsigned.crt \
    -subj "/CN=你的域名/O=自签证书/C=US"
```