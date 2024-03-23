```shell
# 从stdin执行source
source /dev/stdin < <(echo -ne 'f() { echo a; }\n')
source <(echo -ne 'f() { echo a; }\n')

# 从base64
source /dev/stdin < <(echo -ne $BASE64_ENCODE | base64 -d)
```