[返回主页](../../../README.md)

# 新手上路

1. 设置用户基本信息

	* `git config --global user.name 'iGuoji'`

	* `git config --global user.email 'asgeg@qq.com'`

2. 设置远程秘钥配对

	* `ssh-keygen -t rsa -C 'asgeg@qq.com'`，复制id_rsa.pub中的内容到github中

	* `ssh -T git@github.com`

3. 管理远程仓库信息

	* `git remote add 远程仓库名 git@github.com:iguoji/mygit.git`

	* 可以在本地仓库的`.git`文件夹中`config`文件里看到远程仓库信息

4. 提交信息到仓库里

	* `git status` 可以查看本地仓库的文件变化

	* `git add .` 可以将本地的所有有变化的文件提交到缓存区

	* `git commit -m '修改信息'` 可以提交到仓库

	* `git push origin master` 可以将信息提交到远程仓库的master分支

# Git的使用

`.gitignore`文件可以设置忽略某些文件的上传

`git config --global alias.名称 'commit'`：可以给命令设置别名

`ssh-keygen -t rsa -C "github邮箱地址"`：生成本地的sshKey

`ssh -T git@github.com`：验证本地与github是否已经可以正常交互


## 快速操作

`git init`：初始化本地仓库

`git add 文件名`：将工作区的指定文件提交的暂存区，如果文件名为`.`则提交所有有修改的文件

`git commit -m "信息"`：将暂存区的内容提交到仓库

`git remote add 远程仓库名 git@github.com:iguoji/mygit.git`: 关联到一个远程仓库

`git push 远程仓库名 分支名`：将本地仓库的内容推送到远程仓库的指定分支中

`git push -u 远程仓库名 分支名`：将本地仓库的指定分支关联到远程仓库的指定分支，并推送

`git pull`：将远程仓库的内容拉取到本地并合并内容

`git clone git@github.com:iguoji/mygit.git`：克隆远程仓库

## 配置信息

每个仓库的配置文件放在`.git/config`文件中，全局配置文件放在当前用户主目录下的`.gitconfig`文件中

`git config user.name`：设置当前用户的昵称，可加`--global`设置成全局

`git config user.email`：设置当前用户邮箱地址

`git config -l`：查看当前配置信息里的所有内容

## 多人协作

一：`git push 远程仓库名 分支名`，将本地的内容推送到远程仓库中

二：`git pull`，假如有冲突报错，可以选择将远程的内容拉取到本地

三：`git branch --set-upstream 本地分支名 远程仓库名/分支名`，假如拉取失败，则指定远程与本地分支的关联

四：然后在`pull`，如果有合并冲突，手动改代码，然后提交、`push`

## 关于分支

`git branch`：查看分支，加上`-r`表示查看远程分支，加上`-a`表示查看所有分支

`git branch 分支名`：创建新的分支

`git checkout 分支名`：切换到指定的分支

`git checkout -b 分支名`：创建并切换到指定的分支

`git merge 分支名`：合并指定分支到当前分支

`git branch -d 分支名`：删除指定分支

`git branch -D 分支名`：强行删除指定分支，未合并的分支需要使用强制删除

## 标签管理

`git tag`：查看所有标签

`git tag 标签名`：创建标签、默认为最新一次commit的ID

`git tag 标签名 commitID`：给指定的commitID设置标签

`git show 标签名`：查看标签的详细信息

`git tag -d 标签名`：删除本地标签

`git push 远程仓库名 标签名`：推送标签到远程仓库，如果标签名是`--tags`则会将所有标签全部推送

`git push 远程仓库名 :refs/tags/标签名`：删除本地标签


## 隐藏内容

`git stash`：隐藏本地仓库中还未提交的内容，同时将工作区恢复到上一次提交时的状态

`git stash list`：查看隐藏列表

`git stash clear`：清空隐藏列表

`git stash apply`：将隐藏起来的内容恢复出来和新的内容合并