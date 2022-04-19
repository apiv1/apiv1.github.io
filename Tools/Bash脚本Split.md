### 取最后一块

You can use string operators:
```bash
$ foo=1:2:3:4:5
$ echo ${foo##*:}
5
```
This trims everything from the front until a ':', greedily.

```bash
${foo  <-- from variable foo
  ##   <-- greedy front trim
  *    <-- matches anything
  :    <-- until the last ':'
 }
```

### 取去掉主机名的镜像路径
```bash
item=docker.io/minio/minio:latest
$(echo $item | sed -e 's/^[^\/]*\///g') # minio/minio:latest
```

### 扩展名
```bash
${TARGET_FILE##*.}
```

### 去扩展名
```bash
$${TARGET_FILE%.*}
```