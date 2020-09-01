# 建议选项

## [--prefix](#--prefixdir)
## [--with-config-file-path](#--with-config-file-pathpath)
## [--with-config-file-scan-dir](#--with-config-file-scan-dirpath)
## [--with-pear](#--with-peardir)
## [--enable-fpm](#--enable-fpm-1)
## [--with-openssl](#--with-openssl-1)
## [--with-pcre-jit](#--with-pcre-jit-1)
## [--without-sqlite3](#--without-sqlite3-1)
## [--enable-bcmath](#--enable-bcmath-1)
## [--with-gmp](#--with-gmpdir)
## [--with-curl](#--with-curl-1)
## [--enable-gd](#--enable-gd-1)
## [--with-jpeg](#--with-jpeg-1)
## [--with-freetype](#--with-freetype-1)
## [--enable-mbstring](#--enable-mbstring-1)
## [--enable-pcntl](#--enable-pcntl-1)
## [--without-pdo-sqlite](#--without-pdo-sqlite-1)
## [--with-pdo-mysql](#--with-pdo-mysqldir)
## [--with-zlib-dir](#--with-zlib-dirdir)

```bash
./configure \
    --prefix=/opt/php-8.0.0beta2 \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --with-pear \
    --enable-fpm \
    --with-openssl \
    --with-pcre-jit \
    --without-sqlite3 \
    --enable-bcmath \
    --with-gmp \
    --with-curl \
    --enable-gd \
    --with-jpeg \
    --with-freetype \
    --enable-mbstring \
    --enable-pcntl \
    --without-pdo-sqlite \
    --with-pdo-mysql \
    --with-zlib-dir
make && make install
```

# 安装目录

## --prefix=DIR

PHP具体安装到哪个目录，默认值 `/usr/local`

例如安装到`/opt/php8`这个目录，可以 `--prefix=/opt/php8`

## --exec-prefix=DIR

不确定，默认值和 `--prefix` 保持一致

猜测，PHP依赖文件路径、PHP中可执行文件(如fpm之类)的路径

# SAPI 模块

## --with-apxs2=FILE

使用 Apache 的用户最好开启该选项

启用 apxs(apache extension tool) Apache的模块管理工具

`FILE` 示例--with-apxs2=/usr/local/apache/bin/apxs

## --disable-cli

禁用PHP的Cli版本，无法使用命令行执行PHP

## --enable-embed=TYPE

PHP所编译出来的SAPI接口，是否可以让第三方程序调用，例如CLI、PHP-FPM等

## --enable-fpm

启用PHP-FPM，连通Nginx、Apache、IIS到PHP的CGI进程管理器

## --with-fpm-user=USER

FPMy运行程序的用户，默认 `nobody`

## --with-fpm-group=GROUP

FPM运行程序的用户组，默认 `nobody`

## --with-fpm-systemd

开启后将FPM的状态信息报告给系统

原本还以为是方便 `systemctl restart php-fpm`，结果不是，如果要达到这个效果，可以将安装包目录下的 `sapi/fpm/php-fpm.service` 复制到 `/usr/lib/systemd/system/php-fpm.service`，然后 `systemctl daemon-reload` 就OK了

## --with-fpm-acl

使用 `POSIX` 访问控制列表 (默认 - no) 5.6.5版本起有效，`POSIX` 大概是一套有关API接口的编程标准

该选项应该是与下面的选项联合使用

## --with-fpm-apparmor

`apparmor` 是一个类似 `selinux` 的安全模块，可以通过配置文件来控制PHP-FPM的行为，比如是否可以打开端口、打开哪些端口、是否可以操作文件、可以操作哪些文件等

## --enable-fuzzer

`fuzzer` 是一个漏洞检查工具，估计是给PHP源码开发人员用的

## --enable-fuzzer-msan

与上例配合使用

## --enable-litespeed

`litespeed` 是一个类似 `Nginx` 的支持高并发Web服务器，分商业版(收费)和标准版(免费)，国内使用者较少

## --enable-phpdbg

`phpdbg` 是一个PHP的调试工具，类似 `xdebug`

## --enable-phpdbg-webhelper

与上例配合使用

## --enable-phpdbg-debug

与上例配合使用

## --enable-phpdbg-readline

与上例配合使用

## --disable-cgi

禁用CGI

## --with-valgrind

`valgrind` 是一个查找内存泄漏的工具，看起来很复杂

# 常规设置

## --enable-gcov

`gcov` 是一个代码覆盖率测试工具，可以统计到每一行代码的执行频率

## --enable-debug

编译的时候加入调试符号，应该是方便于PHP源码、扩展插件开发人员使用的

## --enable-debug-assertions

同上使用

## --enable-rtld-now

没有找到资料，关键字 dlopen，动态加载库文件？

## --with-layout=TYPE

可选PHP|GNU，默认PHP，都说是安装后的文件布局，啥布局，没搞懂，是说安装后文件夹的名称、层次、位置的不同吗？

## --with-config-file-path=PATH

`php.ini`的文件位置，例如 `--with-config-file-path=/etc/php.ini` ，安装完后需要自己复制一份到这个位置去

## --with-config-file-scan-dir=PATH

PHP 启动时，会先按上例路径加载 `php.ini` 文件，随后加载本例中的所有 `*.ini`文件

例如 `--with-config-file-scan-dir=/etc/php.d`，那么PHP加载完`php.ini`后，将再次扫描`/etc/php.d/`文件夹下的所有`ini`配置文件

## --enable-sigchild

启用PHP自己的 `SIGCHLD` 信号处理函数，当子进程退出时，会向父进程发送 `SIGCHLD` 信号

## --enable-libgcc

启用 libgcc 的精确链接，不懂啥意思。

## --disable-short-tags

禁用短标签，例如 `<? ?>`，通常都是`<?php ?>`

## --enable-dmalloc

`dmalloc` 是内存泄漏检查工具，可以找出是哪个文件第几行造成的

但并没有什么卵用，没有相关的PHP中文资料

## --disable-ipv6

禁用 IPV6

## --enable-dtrace

`dtrace` 是动态跟踪调试工具，很多操作系统内置该工具

PHP官网提供了相关资料 [https://www.php.net/manual/zh/features.dtrace.php](https://www.php.net/manual/zh/features.dtrace.php)

## --enable-fd-setsize

好像和WebSocket、长链接之类的有关，默认`1024`，表示最多支持`1024`个链接，可以改大点

## --enable-werror

好像和安装PHP时的GCC有关，会将所有警告当初错误来处理，似乎和PHP没有关系

## --enable-memory-sanitizer

`sanitizer` 好像也是用来做内存分析的，但仍旧没有PHP相关的中文资料

# 扩展相关

## --disable-all

禁用默认启用的所有扩展

## --without-libxml

`libxml` 通常与 `SimpleXML`、`XSLT`、`DOM` 等操作XML相关的函数一起使用，所以不建议移除

## --with-openssl

`openssl` 提供了许多加密解密函数，建议开启，需要本机安装了 `OpenSSl 1.0.1` 以上版本

## --with-kerberos

`kerberos` 是一种类似 `JWT` 的网络授权协议，大致过程就是先拿到令牌密钥然后可以不用进行验证就随便调用接口，需要 `openssl` 的支持

## --with-system-ciphers

大概是 `openssl` 进行加密处理时所用的密钥从系统获取

## --with-external-pcre

`pcre` 是PHP对文本进行正则表达式处理的内置包，开启该选项可以使用外部的 `pcre` 进行处理

## --with-pcre-jit

`jit` 是即时编译功能，`pcre` 是处理正则的功能，所以是不是 采用实时编译的正则表达式来处理文本？

## --without-sqlite3

`sqlite` 是一种小型的数据库，这辈子不知道有没有机会用到。

## --with-zlib

通常使用 `zlib` 包来开启网站的 `gzip` 压缩功能，但是 `Nginx` 都能处理了，这个没有必要了吧

## --enable-bcmath

`bcmath` 用来处理高精度的数字加减乘除，建议开启

## --with-bz2[=DIR]

`Bzip2` 用于读写 `.bz2` 压缩文件

## --enable-calendar

日历扩展包，用于转换不同日历格式的函数

## --disable-ctype

用于检查字符串是否包含指定类型的其他字符串，性能比正则或其他字符串相关函数都高，官网建议开启

## --with-curl

用于链接通讯到其他服务器，支持各种协议，必须开启

## --enable-dba

`dba` 是一种抽象的数据库风格，很早之前的操作系统会内置一种实现`dba`风格的小型数据库

所以 `dba` 像是PHP里的 `interface` 接口，以至于开启后更多的需要配合下面的选项来使用

## --with-qdbm[=DIR]

参考 `dba`

## --with-gdbm[=DIR]

参考 `dba`

## --with-ndbm[=DIR]

参考 `dba`

## --with-db4[=DIR]

参考 `dba`

## --with-db3[=DIR]

参考 `dba`

## --with-db2[=DIR]

参考 `dba`

## --with-db1[=DIR]

参考 `dba`

## --with-dbm[=DIR]

参考 `dba`

## --with-tcadb[=DIR]

参考 `dba`

## --with-lmdb[=DIR]

参考 `dba`

## --without-cdb[=DIR]

参考 `dba`

## --disable-inifile

参考 `dba`

## --disable-flatfile

参考 `dba`

## --disable-dom

用于操作XML、HTML节点，不建议关闭，按官网的意思需要开启 `libxml` 才能操作 XML\HTML，但是 `libxml` 是默认就开启了的

## --with-enchant

暂时用不到，国际化与字符编码支持

没找到相关资料，看到一个Python的例子，大概是先设置区域为`us`，然后有一个变量的值为 `Helo`，经`enchant_check(变量)` 检查后返回 `false`，应该的值是 `Hello`
总结下来的关键字应该是，词典、各个区域的语义之类的功能吧

## --enable-exif

通过使用 `exif` 扩展，你可以操作图像元数据。 例如：你可以使用 `exif` 相关的函数从数码相机拍摄的图片文件中读取元数据。 通常 JPEG 和 TIFF 格式的图像文件都包含元数据。

但现在图片等资源都放在云上了，应该也用不到了

## --with-ffi

PHP7.4开始提供一种全新的扩展方式，通过开启 `ffi`，可以直接与其他语言写的库文件进行交互

暂时还用不到，太高级了，[鸟哥博客实战](https://www.laruence.com/2020/03/11/5475.html)

## --disable-fileinfo

禁用以 `finfo_` 开头的文件信息相关的函数

## --disable-filter

通常用来过滤变量，比如验证邮箱、IP、URL等，很实用

## --enable-ftp

操作FTP，用不到

## --with-openssl-dir

是否支持FTP SSL 连接

## --enable-gd

`gd` 通常用于处理图片，比如缩略图，所以开启还是有用的

PHP7.4以前，要操作PNG图片还需要 `--with-png-dir` 和 `--with-zlib-dir`，现在不需要了，但是 `zlib` 包还是必须要有的

## --with-external-gd

大概是说使用外部的 `gd` 库，而非PHP内置的 `gd` 库

## --with-webp

让 `gd` 库支持 `.webp` 格式的文件

## --with-jpeg

让 `gd` 库支持 `.jpg` 格式的文件

## --with-xpm

让 `gd` 库支持 `.xpm` 格式的文件

## --with-freetype

`FreeType` 是高质量的字体引擎，大概是处理图片的时候同时处理文本吧

## --enable-gd-jis-conv

网上很多说通过 `gd` 在图片上写汉字的时候导致乱码都是因为这个选项引起的

## --with-gettext[=DIR]

暂时用不到，国际化与字符编码支持

`gettext` 函数实现了NLS (Native Language Support) API，他可以用来国际化您的PHP程序

## --with-gmp[=DIR]

是用来操作任意精度数字的加减乘除之类的数学函数

## --with-mhash

提供一系列以 `mhash_` 开头的加密函数

## --without-iconv[=DIR]

`iconv` 通常用来转换编码，不建议移除

## --with-imap[=DIR]

提供了可以操作 IMAP 以及 NNTP，POP3 和本地邮箱的方法

## --with-kerberos

参考 `with-imap`，大概是可支持 `kerberos` 网络协议

## --with-imap-ssl

参考 `with-imap`，支持 `ssl` 协议

## --enable-intl

暂时用不到，国际化与字符编码支持

## --with-ldap[=DIR]

LDAP(Lightweight Directory Access Protocol)的意思是"轻量级目录访问协议"，是一个用于访问"目录服务器"(Directory Servers)的协议

## --with-ldap-sasl

同上

## --enable-mbstring

提供很多以 `mb_` 开头的用来处理字符串的函数，很实用。

## --disable-mbregex

禁用以正则表达式来处理 `mb_` 系列函数，如果不禁用，那么系统需要安装额外的`oniguruma`库

## --with-mysqli[=FILE]

老版本的PHP中，通过 `mysql` 扩展来操作 MYSQL，新版提供了 `mysqli`，其意为 MYSQL增强版扩展

但现在基本使用 `PDO`，所以该扩展通常不需要

该选项的 `FILE` 指向 `mysql_config` 文件

## --with-mysql-sock[=SOCKPATH]

使用 MySQLi/PDO_MYSQL 扩展时，可通过该选项设置 MYSQL 的 socket 文件地址

## --with-oci8[=DIR]

连接操作 `Oracle` 用的， `DIR` 默认指向 `$ROACLE_HOME`

## --with-odbcver[=HEX]

强行支持某种 `ODBC` 版本， `HEX` 是十六进制的值，默认为 `0x0350`

## --with-adabas[=DIR]

同上， 使 `ODBC` 支持 `Adabas D`，`DIR` 是 `Adabas D` 的基本安装目录，默认为 `/usr/local`

## --with-sapdb[=DIR]

同上， 使 `ODBC` 支持 `SAP DB`，`DIR` 是 `SAP DB` 的基本安装目录，默认为 `/usr/local`

## --with-solid[=DIR]

同上， 使 `ODBC` 支持 `Solid`，`DIR` 是 `Solid` 的基本安装目录，默认为 `/usr/local`

## --with-ibm-db2[=DIR]

同上， 使 `ODBC` 支持 `IBM DB2`，`DIR` 是 `IBM DB2` 的基本安装目录，默认为 `/home/db2inst1/sqllib`

## --with-empress[=DIR]

同上， 使 `ODBC` 支持 `Empress`，`DIR` 是 `Empress` 的基本安装目录，默认为 `$EMPRESSPATH`

## --with-empress-bcs[=DIR]

同上， 使 `ODBC` 支持 `Empress Local Access`，`DIR` 是 `Empress Local Access` 的基本安装目录，默认为 `$EMPRESSPATH`

## --with-custom-odbc[=DIR]

参考 `odbc` 相关内容

## --with-iodbc

参考 `odbc` 相关内容

## --with-esoob[=DIR]

参考 `odbc` 相关内容

## --with-unixODBC

参考 `odbc` 相关内容

## --with-dbmaker[=DIR]

参考 `odbc` 相关内容

## --disable-opcache

`OPcache` 通过将 PHP 脚本预编译的字节码存储到共享内存中来提升 PHP 的性能， 存储预编译字节码的好处就是 省去了每次加载和解析 PHP 脚本的开销。

可千万别禁用了

## --disable-huge-code-pages

配合 `OPcache` 使用，别禁用

## --disable-opcache-jit

配合 `OPcache` 使用，别禁用

## --enable-pcntl

处理系统进程，例如 `workerman` 就很需要这个扩展

## --disable-pdo

禁用 `pdo` 扩展，这样就用不了 `pdo_` 系列函数来操作数据库了

## --with-pdo-dblib[=DIR]

可操作 `Sql Server` 数据库，即 MSSQL

## --with-pdo-firebird[=DIR]

可操作 `firebird` 数据库

## --with-pdo-mysql[=DIR]

可操作 `mysql` 数据库，`DIR` 是MySQL的基本目录，如果不填写，则自动去找

## --with-zlib-dir[=DIR]

针对 `pdo-mysql` 启用 `zlib` 支持，我在安装php7.4的时候 `DIR` 没有填写也安装好了

## --with-pdo-oci[=DIR]

可操作 `oracle` 数据库

## --with-pdo-odbc=flavour,dir

可操作 `odbc` 和 `db2` 数据库

## --with-pdo-pgsql[=DIR]

可操作 `PostgreSQL` 数据库

## --without-pdo-sqlite

移除 `PDO` 对 `Sqlite` 数据库的支持

## --with-pgsql[=DIR]

支持 `PostgreSQL`， `DIR` 是基本安装目录或者 `pg_config` 地址

## --disable-phar

`phar` 是PHP的编译文件，类似Java的JAR包

## --disable-posix

参考 `workerman` 对其的介绍，`posix` 扩展使得PHP在Linux环境可以调用系统通过POSIX标准提供的接口。

WorkerMan主要使用了其相关的接口实现了守护进程化、用户组控制等功能。此扩展win平台不支持。

## --with-pspell[=DIR]

暂时用不到，国际化与字符编码支持

用来检查单词并给出建议

## --with-libedit

针对命令行的扩展，按官网意思，主要用来操作命令行里的历史记录，比如通常按向上键的时候，是显示上一个命令，看样子可以通过这个来修改

## --with-readline[=DIR]

同上

## --disable-session

禁用 `Session`

## --with-mm[=DIR]

将 `Session` 保存到内存，也用不到，通常保存到Redis以供集群使用

## --enable-shmop

提供给了几个以 `shmop_` 开头用来操作内存的函数

## --disable-simplexml

提供了以最简单的方式来操作XML的函数，不建议禁用

## --with-snmp[=DIR]

通过“简单的网络管理协议”管理远程设备

## --enable-soap

类似微服务，先用XML语法写一个WSDL文件，里面描述了接口的情况，然后服务端载入该文件并实现具体方法

最后客户端载入该文件，并传递参数调用接口

## --enable-sockets

支持 `socket`，但好像没什么人用

## --with-sodium

提供了一系列的加密函数

## --with-password-argon2[=DIR]

和 `password_` 系列加密函数有关

## --enable-sysvmsg

对系统IPC系列功能的包装，比如操作共享内存，在进程之间传递消息

## --enable-sysvsem

同上

## --enable-sysvshm

同上

## --with-tidy[=DIR]

对XML\HTML等文件进行清理和纠错

## --disable-tokenizer

`tokenizer`可用来分析PHP源代码

## --disable-xml

`xml` 可用来处理XML文件

## --with-expat

`expat` 是一个XML的解析器

## --disable-xmlreader

`xmlreader` 可以用来读取XML文件

## --disable-xmlwriter

`xmlwriter` 可以用来生成XML文件

## --with-xsl

`xls`是 一种用于以可读格式来呈现XML数据的语言

## --enable-zend-test

大概是Zend引擎的测试模块

## --with-zip

压缩或解压ZIP文件

## --enable-mysqlnd

可操作 `mysql` 数据库

## --disable-mysqlnd-compression-support

禁用MYSQL的压缩协议

# PEAR
## --with-pear[=DIR]

启用 `pear`，`DIR` 默认目录是 `PREFIX/lib/php`