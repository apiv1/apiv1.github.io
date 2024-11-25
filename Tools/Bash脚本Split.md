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

```shell
$ foo=1:2:3:4:5
$ echo ${foo##*:}
5
```

This trims everything from the front until a ':', greedily.

```shell
${foo  <-- from variable foo
  ##   <-- greedy front trim
  *    <-- matches anything
  :    <-- until the last ':'
 }
```

### 取去掉主机名的镜像路径

```shell
item=docker.io/minio/minio:latest
$(echo $item | sed -e 's/^[^\/]*\///g') # minio/minio:latest
```

### 扩展名

```shell
TARGET_FILE=1.tar.gz
echo ${TARGET_FILE#*.} # tar.gz
echo ${TARGET_FILE##*.} # gz
```

### 去扩展名

```shell
TARGET_FILE=1.tar.gz
echo ${TARGET_FILE%.*} # 1.tar
echo ${TARGET_FILE%%.*} # 1
```

### 替换换行符

```shell
awk '{{printf"%s\\n",$0}}'
```

### 字符串split成数组
按照特定字符分割, 不分割空格
```shell
my_string="Ubuntu;Linux Mint;Debian;Arch;Fedora"
IFS=';' read -ra my_array <<< "$my_string"

#Print the split string
for i in "${my_array[@]}"
do
    echo $i
done
```

遇到空格会分割
```shell
my_string="Ubuntu;Linux Mint;Debian;Arch;Fedora"
my_array=($(echo $my_string | tr ";" "\n"))

#Print the split string
for i in "${my_array[@]}"
do
    echo $i
done
```

取HOST:PORT
```shell
HOST=${HOST_ADDR%%:*}
PORT=$(echo $HOST_ADDR | sed 's/^[^:]*[:]*//g')
```

提取文件中引号内的内容
```shell
awk -F'"' '{for(i=2; i<=NF; i+=2) print $i}' example.txt
```

大小写
```shell
# 把变量中的第一个字符换成大写
echo ${var^}
# 把变量中的所有小写字母，全部替换为大写
echo ${var^^}
# 把变量中的第一个字符换成小写
echo ${var,}
# 把变量中的所有大写字母，全部替换为小写
echo ${var,,}
```