### 合并yml
```shell
yq eval-all 'select(fileIndex == 0) *+ select(fileIndex == 1)' a.yml b.yml > c.yml
```