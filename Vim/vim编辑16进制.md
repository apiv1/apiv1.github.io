```shell
vim -b data.bin # 二进制模式打开， 等同 :set binary
:%!xxd               # 转换为十六进制视图
# 编辑十六进制区域（注意只改中间的数据部分，不要修改偏移量和ASCII区域）
:%!xxd -r            # 转换回二进制并保存
```