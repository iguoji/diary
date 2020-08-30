#### 安装目录

##### √ --prefix

PHP具体安装到哪个目录，默认值 `/usr/local`

例如安装到`/opt/php8`这个目录，可以 `--prefix=/opt/php8`

##### --exec-prefix

不确定，默认值和 `--prefix` 保持一致

猜测，PHP依赖文件路径、PHP中可执行文件(如fpm之类)的路径

#### SAPI 模块

##### --with-apxs2

启用 apxs(apache extension tool) Apache的模块管理工具

##### --disable-cli

禁用PHP的Cli版本，无法使用命令行执行PHP

##### --enable-embed

PHP所编译出来的SAPI接口，是否可以让第三方程序调用，例如CLI、PHP-FPM等

##### √ --enable-fpm

启用PHP-FPM，连通Nginx、Apache、IIS到PHP的CGI进程管理器

##### --with-fpm-user

FPMy运行程序的用户，默认 `nobody`

##### --with-fpm-group

FPM运行程序的用户组，默认 `nobody`

##### √ --with-fpm-systemd

是否自动将 PHP-FPM 程序加入系统服务，方便 `systemctl restart php-fpm`

即便没有启用该选项，在PHP的安装包目录下也有相关文件可供直接复制

##### --with-fpm-acl

使用 `POSIX` 访问控制列表 (默认 - no) 5.6.5版本起有效，`POSIX` 大概是一套有关API接口的编程标准

该选项应该是与下面的选项联合使用

##### --with-fpm-apparmor

`apparmor` 是一个类似 `selinux` 的安全模块，可以通过配置文件来控制PHP-FPM的行为，比如是否可以打开端口、打开哪些端口、是否可以操作文件、可以操作哪些文件等

##### --enable-fuzzer

`fuzzer` 是一个漏洞检查工具，估计是给PHP源码开发人员用的

##### --enable-fuzzer-msan

与上例配合使用

##### --enable-litespeed

`litespeed` 是一个类似 `Nginx` 的支持高并发Web服务器，分商业版(收费)和标准版(免费)，国内使用者较少

##### --enable-phpdbg

`phpdbg` 是一个PHP的调试工具，类似 `xdebug`

##### --enable-phpdbg-webhelper

与上例配合使用

##### --enable-phpdbg-debug

与上例配合使用

##### --enable-phpdbg-readline

与上例配合使用

##### --disable-cgi

禁用CGI

##### --with-valgrind

`valgrind` 是一个查找内存泄漏的工具，看起来很复杂

#### 常规设置

##### --enable-gcov
##### --enable-debug
##### --enable-debug-assertions
##### --enable-rtld-now
##### --with-layout=TYPE
##### --with-config-file-path=PATH
##### --with-config-file-scan-dir=PATH
##### --enable-sigchild
##### --enable-libgcc
##### --disable-short-tags
##### --enable-dmalloc
##### --disable-ipv6
##### --enable-dtrace
##### --enable-fd-setsize
##### --enable-werror
##### --enable-memory-sanitizer