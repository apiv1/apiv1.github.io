# Git快速上手

从仓库复制项目到本地
```shell
git clone $REPO_URL
git clone --recurse-submodules --depth=1 $REPO_URL # 拉取所有子模块, 变更拷贝深度为1, 减少体积.(常用于仅使用项目, 不做变更和提交)
```

更新本地项目
```shell
git pull origin $BRANCH_NAME
git pull --rebase origin $BRANCH_NAME # 变基拉取远程分支, 重做本地已有未提交变更(推荐使用)
git pull -f origin $BRANCH_NAME # 强制拉取远程分支
```

本地开新分支进行开发
```shell
git checkout -b $NEW_BRANCH_NAME
```

添加本地变更
```shell
git add . # 所有本地变更
git add $FILE_NAME # 添加指定文件名的变更
```

提交变更
```shell
git commit
git commit -a -m '写注释' # 自动添加本地变更, 并写注释
```

查看状态
```shell
git status # 当前状态
git log # 历史状态
```

回退本地改动
```shell
git reset . # 放弃所有被git add的改动
git checkout . # 退回到未变更的状态
git clean -f # 删除未被git管理的文件
```

将本地分支更新到远程
```shell
git push origin $BRANCH_NAME
git push -f origin $BRANCH_NAME # 强制推送, 忽略远程分支和本地差异, 强制远程使用本地分支, 慎用.
```