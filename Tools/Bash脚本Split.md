### 说明
1. ${variable#pattern}
如果pattern匹配variable的开始部分，从variable的开始处删除字符直到第一个匹配的位置，包括匹配部分，返回剩余部分。

2. ${variable##pattern}
如果pattern匹配variable的开始部分，从variable的开始处删除字符直到最后一个匹配的位置，包括匹配部分，返回剩余部分。

3. ${variable%pattern}
如果pattern匹配variable的结尾部分，从variable的结尾处删除字符直到第一个匹配的位置，包括匹配部分，返回剩余部分。

4. ${variable%%pattern}
如果pattern匹配variable的结尾部分，从variable的结尾处删除字符直到最后一个匹配的位置，包括匹配部分，返回剩余部分。

5. ${variable/pattern/string} 匹配单个替换
6. ${variable//pattern/string} 匹配所有替换

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
${TARGET_FILE%.*}
```