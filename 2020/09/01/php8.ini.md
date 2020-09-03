## 有意思的

+ [precision](#precision)

+ [expose_php](#expose_php)

+ [资源限制](#资源限制)

+ [auto_globals_jit](#auto_globals_jit)

+ [post_max_size](#post_max_size)

+ [很多cgi相关的搞不懂](#路径和目录)

## 个人测试

```ini
; 无需子配置文件
user_ini.filename = ""

; 不用Apache
engine = Off

; 不用重写，前后端分离，纯API接口服务器
url_rewriter.tags = ""

; 不用告诉客户端我是用PHP写的接口
expose_php = Off

; 开发期间 128M，上线后看情况
memory_limit = 128M

; 不需要HTML格式的错误信息
html_errors = Off
```

## 配置选项

### user_ini.filename

默认值：`user_ini.filename = ".user.ini"`

在CLI命令行模式中无效。

在Nginx+PHP-FPM中实测，如果当前路径的目录下存在`.user.ini`文件，则该文件中的内容会覆盖上层目录下`.user.ini`的内容，然后这样依次一直覆盖到根目录`$_SERVER['DOCUMENT_ROOT']`，最终将会覆盖`php.ini`文件里的内容

例如`.user.ini`中设置`memory_limit = 1024M`，而`php.ini`中`memory_limit = 128M`，这样实际的效果是`1024M`

**但哪些值可以修改，改了是否能够生效，还有待测试**

可以通过 `user_ini.filename = ` 取消该文件

### user_ini.cache_ttl

默认值：`user_ini.cache_ttl = 300`

配合 `user_ini.filename` 使用，即300秒读取一次用户自定义配置文件

实测结果，前几秒刷新能得到覆盖后的结果，但大概`2秒`后再刷新，得到的就是原本的值了，也许是其他配置选项造成的影响，等确认后再来修改这里的描述

## 语言选项

### engine

默认值：`engine = On`

在Apache中打开或关闭PHP解析功能，仅Web服务器为Apache的时候该选项才有用，Nginx实测即时改成`off`也不会有什么影响

### short_open_tag

默认值：`short_open_tag = Off`

以前写PHP的时候，代码规范并不统一，例如：

`<?php echo 'Hello World'; ?>`

`<? echo 'Hello World'; ?>`

`<?= 'Hello World'; ?>`

结果是相同的，其中 `<?php ?>` 这种方式属于正常的，后两者属于 **短标签**，渐渐被弃用

现在默认无法使用 **短标签**，但可以通过该选项来开启后使用

### precision

默认值：`precision = 14`

浮点型数值显示的时候，除开小数点外最多显示多少数量，举个例子：

`$a = 100.12345678901234;`，如果`echo`出`$a`，将显示`100.12345678901`，数字共`14`个

`$a = 1000.12345678901234;`，如果`echo`出`$a`，将显示`1000.1234567890`，数字共`14`个

实测对整数型没有影响。

### output_buffering

默认值：`output_buffering = 4096`

开发者使用`echo`或`print`等函数时，PHP会将字符串内容暂时存放到`buffer`缓冲区

等缓冲区的内容数量达到`4096`字节，即`4KB`的时候，就会一次性将所有缓冲区的内容发送到客户端的浏览器上

可以使用 `ob_start(callable $fn)` 函数来达到同样的效果

### output_handler

没有默认值，可以将其值设置为一个内置的PHP函数名

如`output_buffering`中描述的情况，在PHP将缓冲区的内容发送到客户端之前

系统将会调用该值所指的函数，对内容进行处理后再发送到客户端，类似 `echo myFun(string buffer) : string;`

### url_rewriter.tags

默认值：`url_rewriter.tags = "form="`

主要作用在于为`output_add_rewrite_var(string $name, string $value) : bool`这个函数服务，目的是在输出HTML内容的时候，给指定的标签属性或内容中添加一些代码，当然也可以通过`output_reset_rewrite_vars() : bool`取消之前的设置。

```php
<?php
// 调整php.ini中的url_rewriter.tags = "form=,a=href"

// 设置链接参数
output_add_rewrite_var('key', 'value');

// 相对路径会进行添加
// 输出 <a href="page1.php?key=value">Swoole</a>
echo '<a href="one/test.php">Swoole</a>', PHP_EOL;

// 绝对路径不会进行添加
// 输出 <a href="http:/192.168.2.12/one/test.php">iGuoji</a>
echo '<a href="http:/192.168.2.12/one/test.php">iGuoji</a>', PHP_EOL;

// 输出 <form><input type="hidden" name="key" value="value" /><input type="text" name="abc" /></form>
echo '<form><input type="text" name="abc" /></form>', PHP_EOL;
```

### url_rewriter.hosts

默认值：`$_SERVER['HTTP_HOST']`，与`url_rewriter.tags`进行配合使用

在`url_rewriter.tags`中，默认不会对绝对路径进行URL重写，但是可以在此设置需要重写的域名可以

例如：`url_rewriter.hosts = "127.0.0.1,192.168.2.12"`

但是全天下都没人有使用记录，以上均为猜测，实测也没效果，等待以后处理

### zlib.output_compression

默认值：`zlib.output_compression = Off`

有两种值可以设置，第一种，`Off` 或 `On`，表示是否将输出的字符串进行 `gzip` 压缩

第二种值为整数值，类似 `output_buffering`

### zlib.output_compression_level

默认值：`zlib.output_compression_level = -1`

与 `zlib.output_compression` 配合使用，表示具体的压缩级别

### zlib.output_handler

参考 `output_handler`

### implicit_flush

默认值：`implicit_flush = Off`

如果值为 `On`，则表示每次调用 `echo`、`print` 以及其他函数进行内容输出的时候，系统自动刷新 `flush()` 缓冲区

开启后严重影响性能，仅供测试时使用

### unserialize_callback_func

没有默认值，假如我们把一个实例化的对象通过`serialize() : string` 进行序列化

最终会得到一个字符串，然后把序列化好的字符串拿到另一个空项目里进行反序列化时，就可能会出现意外，比如找不到对象的类

此时，`php.ini` 中如果设置了该选项的值，则会调用该选项的值所指向的函数，并将类名作为参数传递过去

### unserialize_max_depth

默认值：`unserialize_max_depth = 4096`

类似递归循环调用最大次数

### serialize_precision

默认值：`serialize_precision = -1`

和序列化浮点数的有效精度相关

### open_basedir

没有默认值，其值是一个目录地址

设置该选项后，PHP中所有文件操作都将被限制在该目录下，例如 `file_get_contents()`

有人[测试](https://blog.csdn.net/fdipzone/article/details/54562656)出该选项略微影响性能，当你准备将服务器上某个目录提供给他人使用时，该选项才有意义

### disable_functions

没有默认值，可以禁用PHP内置函数，多个函数以逗号分隔

### disable_classes

没有默认值，可以禁用某些类，多个类以逗号分隔

### syntax-highlighting

与 `highlight_file(string $filename, bool $return = false)` 进行配合使用，没太看懂意义何在。

+ highlight.string  = #DD0000
+ highlight.comment = #FF9900
+ highlight.keyword = #007700
+ highlight.default = #0000BB
+ highlight.html    = #000000

### ignore_user_abort

默认值：`ignore_user_abort = Off`

如果启用，即时用户中断请求，程序也将继续执行下去，可以参考函数 `ignore_user_abort(bool $value) : int`

### realpath_cache_size

默认值：`realpath_cache_size = 4096k`

应该与 `realpath()` 函数相关，官网：在 PHP 打开很多文件的系统中，这个值应该增加，以优化文件操作的数量。

### realpath_cache_ttl

默认值：`realpath_cache_ttl = 120`

与 `realpath_cache_size` 相关，单位为秒

### zend.enable_gc

默认值：`zend.enable_gc = On`

是否启用垃圾回收机制

### zend.multibyte

默认值：`zend.multibyte = Off`

是否启用多字节编码的源文件解析功能，例如 `CP936`, `Big5`, `CP949`， `Shift_JIS`，但是 `UTF-8` 之类的不在此限制中

### zend.script_encoding

没有默认值，在编译特殊的字符编码源文件时，该选项和 `zend.multibyte` 必须有一个开启了

### zend.exception_ignore_args

默认值：`zend.exception_ignore_args = On`，目的是从异常产生的堆栈中排除一些较为敏感的参数

### zend.exception_string_param_max_len

默认值：`zend.exception_string_param_max_len = 0`，启用 `zend.exception_ignore_args` 时，该选项无效。

允许将字符串化堆栈跟踪的参数中的最大字符串长度设置为0到1000000之间的值。

在生产中，建议将该值设置为0以减少堆栈跟踪中敏感信息的输出

## 杂项配置

### expose_php

默认值：`expose_php = On`，是否对外暴漏PHP信息

开启时，HttpResponse中将输出 `X-Powered-By: PHP/8.0.0beta2`，关闭后就看不见了

## 资源限制

### max_execution_time

默认值：`max_execution_time = 30`

PHP脚本执行最大时限，单位秒，在命令行CLI模式允许时，该值为 `0`，即不限制

### max_input_time

默认值：`max_input_time = 60`

接收数据的最大时限，类似`POST`、`GET`，单位秒

### max_input_vars

默认值：`max_input_vars = 1000`

每次最多能接收多少个变量，比如`POST`、`GET`、`Cookie`等提交请求时进行判断

### memory_limit

默认值：`memory_limit = 128M`

脚本执行时最多占用的内存容量，数值小点更能检查出内存占用和泄漏，当并发量上去后就调大些。

## 错误处理和日志

### error_reporting

默认值：`error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT`

报告哪些级别的错误信息，通常会在代码中通过 `error_reporting()` 函数来设置

### display_errors

默认值：`display_errors = Off`

是否将脚本运行期间收集到的错误信息输出到客户端，通常会在代码中通过 `ini_set('display_errors', '1')` 来设置

### display_startup_errors

默认值：`display_startup_errors = Off`

是否将PHP启动期间收集到的错误信息输出到客户端

### log_errors

默认值：`log_errors = On`

设置是否将脚本运行的错误信息记录到服务器错误日志或者下面 `error_log` 所指向的文件之中。

### log_errors_max_len

默认值：`log_errors_max_len = 1024`

每次记录错误信息到服务器时的最大字节数，设置为 `0` 表示不限制长度。

### ignore_repeated_errors

默认值：`ignore_repeated_errors = Off`

在一个PHP文件的某一行出现的固定错误，将不重复进行记录，除非开启了 `ignore_repeated_source` 选项，这样就不考虑是不是同一个文件的错误信息了

### ignore_repeated_source

默认值：`ignore_repeated_source = Off`，是否忽略来自相同文件的错误信息

### report_memleaks

默认值：`report_memleaks = On`

是否报告内存泄漏消息，可能就是 `Allowed memory size of 1280000 bytes exhausted at` 这类错误吧

### report_zend_debug

默认值：`report_zend_debug = 0`，没有资料

### xmlrpc_errors

默认值：`xmlrpc_errors = 0`

是否关闭正常的错误报告，并将错误的格式设置为XML-RPC错误信息的格式。

### xmlrpc_error_number

默认值：`xmlrpc_error_number = 0`

用作 XML-RPC faultCode 元素的值。

### html_errors

默认值：`html_errors = On`，在页面上显示出的错误信息是否使用HTML标签。

参考 `docref_root` 和 `docref_ext` 的设置

### docref_root

默认值：`docref_root = ""`，可以设置本地目录也可以是远程链接

假如 `html_errors = On`，并且当前选项设置为 `docref_root = "http://192.168.2.12/index.php?arg="`

那么当代码中出现错误的时候，页面上显示的错误就会出现超链接，并将错误的方法名附加在该链接后

例如：`http://192.168.2.12/index.php?arg=function.myFn`

### docref_ext = .html

默认值：`docref_ext = ""`

如上例，将在最后附加上文件后缀，`http://192.168.2.12/index.php?arg=function.myFn.html`

### error_prepend_string

默认值：`error_prepend_string = ""`

错误信息前缀，不受 `html_errors` 影响，假如错误信息是 `Hello World`，并且此选项设置为 `<b>`。

那么最终显示在页面上是代码是 `<b>Hello World`。

### error_append_string

默认值：`error_append_string = ""`

如上例，并且此选项设置为 `</b>`。

那么最终显示在页面上是代码是 `<b>Hello World</b>`。

### error_log

默认值：`error_log = ""`，PHP的错误日志将被记录到哪里

有一个特殊属性 `syslog`，表示错误信息将发送给到系统日志记录器

### syslog.ident

默认值：`syslog.ident = php`

设置每条日志消息前缀的识别字符串（ident string），仅在 `error_log` 为 `syslog` 时有效。

### syslog.facility = user

默认值：`syslog.facility = "LOG_USER"`

指定记录日志信息的程序类型，仅在 `error_log` 设置为 `syslog` 时有效。

### syslog.filter = ascii

默认值：`syslog.filter = "no-ctrl"`，指定日志过滤器类型。

## 数据处理

### arg_separator.output

默认值：`arg_separator.output = "&"`

在 PHP 生成的 URL 中用来分隔参数的分隔符，参考 `http_build_query()` 函数。

### arg_separator.input

默认值：`arg_separator.input = "&"`

PHP 用于将输入的 URL 解析为变量的分隔符列表，本指令中的每一个字符都被视为分隔符！

### variables_order

默认值：`variables_order = "GPCS"`

设置 `$_ENV`、`$_GLOBAL`、`$_POST`、`$_GET`、`$_COOKIE`、`$_SERVER` 等全局变量的解析与否和解析顺序

很有意思的选项，但不建议修改。

### request_order

默认值：`request_order = "GP"`

该指令描述了PHP将 `$_GET`、`$_POST`和`$_COOKIE`变量注册到`$_REQUEST`数组中的顺序。 注册从左到右完成，新值覆盖旧值。

如果未设置此指令，则`$_REQUEST`内容将使用 `variables_order`。

### register_argc_argv

默认值：`register_argc_argv = Off`

告诉PHP是否声明`$argv`和`$argc`变量（该变量将包含`$_GET`信息）。

### auto_globals_jit

默认值：`auto_globals_jit = On`

启用后，`$_SERVER`、`$_REQUEST`和`$_ENV`变量将在首次使用时（及时）而不是在脚本启动时创建。

如果脚本中未使用这些变量，则启用此指令将提高性能。

### enable_post_data_reading

默认值：`enable_post_data_reading = On`

禁用此选项将导致不填充`$_POST`和`$_FILES`。

### post_max_size

默认值：`post_max_size = 8M`

每次提交请求的最大数据量，理论上 `memory_limit` <kbd>></kbd> `post_max_size` <kbd>></kbd> `upload_max_filesize`

如果实际上提交的数据大于 `post_max_size`，则 `$_POST` 和 `$_FILES` 为空。

### auto_prepend_file

默认值：`auto_prepend_file =`

指定一个PHP文件，将在每次执行脚本前运行该PHP文件，以前开发网站的人会通过该选项来加载网页头部代码

### auto_append_file

默认值：`auto_append_file =`

指定一个PHP文件，将在每次执行脚本后运行该PHP文件，以前开发网站的人会通过该选项来加载网页底部代码

### default_mimetype

默认值：`default_mimetype = "text/html"`

指默认情况下 `HttpResponse` 的 `Content-Type`，如果是纯API接口服务器，可以设置为 `application/json`

### default_charset

默认值：`default_charset = "UTF-8"`

很多函数中都存在一个可选的编码参数，如果不填则使用该选项的值，还有用于 `header` 中的默认网页编码。

### internal_encoding

默认值：`internal_encoding =`

从PHP 5.6.0起可用。 此设置用于`mbstring`和`iconv`等多字节模块。 默认为空。 如果为空，则使用`default_charset`。

### input_encoding

默认值：`input_encoding =`，从PHP 5.6.0起可用。 此设置用于mbstring和iconv等多字节模块。 默认为空。

### output_encoding

默认值：`output_encoding =`，从PHP 5.6.0起可用。 此设置用于mbstring和iconv等多字节模块。 默认为空。


## 路径和目录

### include_path

默认值：`include_path = ".:/PHP安装目录/lib/php"`

大概是说PHP在找相对路径的PHP文件的时候，会在哪些目录下寻找

### doc_root

默认值为空，与Nginx中的 `root` 类似

### user_dir
### extension_dir

默认值：`extension_dir = /PHP安装目录/lib/php/extensions/no-debug-non-zts-某个日期`

PHP扩展所在的目录

### sys_temp_dir

默认值：`sys_temp_dir = "/tmp"`，系统存放临时文件的目录，可以通过 `sys_get_temp_dir()` 函数查看到实际目录

### enable_dl

是否允许 `dl()` 函数，该函数允许在Apache环境下的PHP脚本中加载扩展。

### cgi.force_redirect

默认值：`cgi.force_redirect = 1`

说是开启后提高安全性，但没找到别的资料，好像该选项最大的意义就是用户是IIS环境时，将该值设置为 `0`

### cgi.nph

默认值：`cgi.nph = 0`

官网说开启后强制cgi始终发送状态：每次请求200。 PHP的默认行为是禁用此功能。

但实测调用 `http_response_code(500)` 或 `header('HTTP/1.1 500 Internal Server Error')` 后状态就是 `500`

没搞懂

### cgi.redirect_status_env

如果 `cgi.force_redirect` 开启了，而Web服务器不是`Apache`或`iPlanet`，那么需要设置一个环境变量名称

PHP会使用该环境变量名称来确定是否可以继续执行。

没搞懂

### cgi.fix_pathinfo

默认值：`cgi.fix_pathinfo=1`

官网说为CGI提供更好的`PATHINFO`支持，也有人说与 `$_SERVER['PATH_INFO']` 有关

但是没有测试出来，实测结果`PATHINFO`全看`Nginx`给的是什么

### cgi.discard_path

默认值：`cgi.discard_path=0`

官网说：如果启用此功能，则可以将PHP CGI二进制文件安全地放置在Web树之外，并且人们将无法规避.htaccess安全性。

`PHP CGI二进制文件` 是指 `php-cgi.exe` 这个文件么，本身就不会放在Web项目里

没搞懂

### fastcgi.impersonate

默认值：`fastcgi.impersonate = 0`，和IIS有关，不用看了

### fastcgi.logging

默认值：`fastcgi.logging = 1`

使用FastCGI时打开SAPI日志记录。 默认为启用日志记录。

### cgi.rfc2616_headers

默认值：`cgi.rfc2616_headers = 0`

确定PHP回应HTTP响应时发送什么标头，该值为 `1` 则发送符合 `RFC2616` 标准的，否则为 `RFC3875` 标准的

官网说在例如PHP-FPM这样的环境下，不建议启用该选项

### cgi.check_shebang_line

默认值：`cgi.check_shebang_line = 0`

控制CGI PHP是否检查以＃！开头的行！ （shebang）在运行脚本的顶部。

如果脚本支持既作为独立脚本又通过PHP CGI运行，则可能需要此行。

如果启用了此伪指令，则处于CGI模式的PHP将跳过此行，并忽略其内容。

## 文件上传

### file_uploads

默认值：`file_uploads = On`，是否允许Http上传文件

### upload_tmp_dir

默认值：`upload_tmp_dir = `，上传文件时临时存放目录，需保证有读写权限

### upload_max_filesize

默认值：`upload_max_filesize = 2M`，上传时单个文件允许最大的文件大小

### max_file_uploads

默认值：`max_file_uploads = 20`，一次请求最多上传多少个文件

## Fopen wrappers

### allow_url_fopen

默认值：`allow_url_fopen = On`，是否允许 `fopen()`这类函数以 URL形式的参数 打开远程对象

### allow_url_include

默认值：`allow_url_include = Off`，是否允许 `require`、`include` 等函数以 URL形式的参数 打开远程对象

### from

默认值：`from = `，匿名FTP的密码，邮箱格式

### user_agent

默认值：`user_agent = `，各类请求中，PHP默认发送的 `User-Agent`。

### default_socket_timeout

默认值：`default_socket_timeout = 60`，基于 socket 的流的默认超时时间（秒）。

### auto_detect_line_endings

默认值：`auto_detect_line_endings = Off`

当设为 On 时，PHP 将检查通过 fgets() 和 file() 取得的数据中的行结束符号是符合 Unix，MS-DOS，还是 Macintosh 的习惯。

这使得 PHP 可以和 Macintosh 系统交互操作，但是默认值是 Off，因为在检测第一行的 EOL 习惯时会有很小的性能损失，而且在 Unix 系统下使用回车符号作为项目分隔符的人们会遭遇向下不兼容的行为。

## 动态扩展

### extension

没有默认值，目的是添加扩展模块，例如 `extension=redis`，添加多个扩展的话，就复制一行一个

### zend_extension

如上

## 模块设置

### Cli Server

#### cli_server.color

默认值：`cli_server.color = On`，控制内置Web Server的终端输出有无颜色。

### Date

#### date.timezone

默认值：`date.timezone = `，用于所有日期、时间函数的默认时区，也可以通过 `date_default_timezone_set()` 来设置

#### date.default_latitude

默认值：`date.default_latitude = 31.7667`，默认纬度。

#### date.default_longitude

默认值：`date.default_longitude = 35.2333`，默认经度。

#### date.sunrise_zenith

默认值：`date.sunrise_zenith = 90.833333`，默认日出天顶。

#### date.sunset_zenith

默认值：`date.sunset_zenith = 90.833333`，默认日落天顶。

### filter

#### filter.default

默认值：`filter.default = unsafe_raw`

用于过滤所有来自 `$_GET`、`$_POST`、`$_COOKIE`、`$_REQUEST`、`$_SERVER` 的变量数据

可接受的值参考[官网](https://www.php.net/manual/zh/filter.filters.php)，如果要获取原始值可通过 [`filter_input()`](https://www.php.net/manual/zh/function.filter-input.php) 函数

#### filter.default_flags

默认值：`filter.default_flags = `，可选值参考[官网](https://www.php.net/manual/zh/filter.filters.flags.php)，没搞懂

### opcache

#### opcache.enable

默认值：`opcache.enable=1`，确定是否启用 `OPcache`。

#### opcache.enable_cli

默认值：`opcache.enable_cli=0`，确定是否在CLI模式下启用 `OPcache`。

#### opcache.memory_consumption

默认值：`opcache.memory_consumption=128`，设置共享内存的容量（单位M）。

#### opcache.interned_strings_buffer

默认值：`opcache.interned_strings_buffer=8`，设置用来存储预留字符串的内存容量（单位M）。

#### opcache.max_accelerated_files

默认值：`opcache.max_accelerated_files=10000`，内置哈希表，最大可存储脚本数量的上限，可设置 `200` 到 `1000000` 之间。

#### opcache.max_wasted_percentage

默认值：`opcache.max_wasted_percentage=5`，最多可浪费多少百分比的内存，达到此数值将执行重启。

#### opcache.use_cwd

默认值：`opcache.use_cwd=1`，每个PHP脚本存储时是否附带上所在目录，不带目录则略微增加性能但有可能造成重名脚本冲突的意外情况。

#### opcache.validate_timestamps

默认值：`opcache.validate_timestamps=1`，如果启用，那么 `OPcache` 会每隔 `opcache.revalidate_freq` 设定的秒数来检查脚本是否更新缓存。

#### opcache.revalidate_freq

默认值：`opcache.revalidate_freq=2`，配合 `validate_timestamps` 使用，每隔若干秒检查一次

#### opcache.revalidate_path

默认值：`opcache.revalidate_path=0`

说法一：**php.ini**：在优化 `include_path` 时启用或禁用文件搜索。

说法二：**官网文档**：如果禁用此选项，在同一个 `include_path` 已存在的缓存文件会被重用。 因此，将无法找到不在包含路径下的同名文件。

这两处说法没太看懂，感觉有点矛盾，但网上资料大多是建议设置为 `0`。

#### opcache.save_comments

默认值：`opcache.save_comments=1`，是否在编译的缓存文件中保存注释。

#### opcache.record_warnings

默认值：`opcache.record_warnings=0`，是否每次包含文件时都发出警告通知。

#### opcache.enable_file_override

默认值：`opcache.enable_file_override=0`

如果启用，则在调用函数 `file_exists()`、`is_file()`、`is_readable()`的时候会先去检查缓存，无论文件是否已经被缓存。

#### opcache.optimization_level

默认值：`opcache.optimization_level=0x7FFFBFFF`，控制优化级别的二进制位掩码。

#### opcache.dups_fix

默认值：`opcache.dups_fix=0`，启用后将解决重复定义类的错误问题。

例如重复 `include("myClass.php")` 多次引入相同文件，就会报错，但启用该选项就可以暂时避免。

#### opcache.blacklist_filename

默认值：`opcache.blacklist_filename=`

黑名单文本文件的路径，该文本文件中存放不用进行预编译的文件列表

#### opcache.max_file_size

默认值：`opcache.max_file_size=0`，可允许编译后文件的最大字节数，为`0`表示随便编译。

#### opcache.consistency_checks

默认值：`opcache.consistency_checks=0`

如果是非 `0` 值，OPcache 将会每隔 `N` 次请求检查缓存校验和。 `N` 即为此配置指令的设置值。

由于此选项对于性能有较大影响，请尽在调试环境使用。

#### opcache.force_restart_timeout

默认值：`opcache.force_restart_timeout=180`，没事的时候，等待多少秒将会自动重启。

#### opcache.error_log

默认值：`opcache.error_log=`，错误日志文件路径，为空则表示发送到 `stderr`，即 `php-fpm` 或 `nginx` 的错误日志文件中。

#### opcache.log_verbosity_level

默认值：`opcache.log_verbosity_level=1`，OPcache 模块的日志级别。

默认情况下，仅有致命级别（0）及错误级别（1）的日志会被记录。

其他可用的级别有：警告（2），信息（3）和调试（4）。

#### opcache.preferred_memory_model

默认值：`opcache.preferred_memory_model=`，OPcache 首选的内存模块。

如果留空，OPcache 会选择适用的模块， 通常情况下，自动选择就可以满足需求。

可选值包括： `mmap`，`shm`, `posix` 以及 `win32`。

#### opcache.protect_memory

默认值：`opcache.protect_memory=0`，内部调试时用的，保护共享内存，以避免执行脚本时发生非预期的写入。

#### opcache.restrict_api

默认值：`opcache.restrict_api=`，允许指定路径下的PHP文件调用 `opcache` 的函数，留空表示不做限制。

#### opcache.mmap_base

默认值：`opcache.mmap_base=`，在 Windows 平台上共享内存段的基地址。

所有的 PHP 进程都将共享内存映射到同样的地址空间。 使用此配置指令避免“无法重新附加到基地址”的错误。

#### opcache.cache_id

默认值：`opcache.cache_id=`

为每个用户提供多个OPcache实例（仅适用于Windows）。 具有相同缓存ID和用户的所有PHP进程共享一个OPcache实例。

#### opcache.file_cache

默认值：`opcache.file_cache=`，填写一个目录地址启用文件缓存，留空表示禁用基于文件的缓存。

#### opcache.file_cache_only

默认值：`opcache.file_cache_only=0`，启用则禁用基于内存的缓存。

#### opcache.file_cache_consistency_checks

默认值：`opcache.file_cache_consistency_checks=1`，当从文件缓存中加载脚本的时候，是否对文件的校验和进行验证。

#### opcache.file_cache_fallback

默认值：`opcache.file_cache_fallback=0`，在 Windows 平台上，当一个进程无法附加到共享内存的时候， 是否使用基于文件的缓存。

#### opcache.huge_code_pages

默认值：`opcache.huge_code_pages=0`，是否将缓存复制到`HUGE PAGES`，启用则可提高性能，但是需要对系统进行配置。

#### opcache.validate_permission

默认值：`opcache.validate_permission=0`，是否针对当前用户，验证缓存文件的访问权限。

#### opcache.validate_root

默认值：`opcache.validate_root=0`，是否启用以防止在`chroot`环境中发生名称冲突。

#### opcache.opt_debug_level

默认值：`opcache.opt_debug_level=0`，针对不同阶段的优化情况进行调试。

设置为 0x10000 会在进行优化之前输出编译器编译后的操作码。

设置为 0x20000 会输出优化后的操作码。

#### opcache.preload

默认值：`opcache.preload=`，指定一个PHP脚本进行预加载，可以在该PHP脚本文件中使用 `include()` 或者 `opcache_compile_file()` 函数来加载更多的文件。

#### opcache.preload_user

默认值：`opcache.preload_user=`，执行预加载的系统用户。

#### opcache.file_update_protection

默认值：`opcache.file_update_protection=2`

距离文件最后的修改时间不足若干秒时，该文件将不执行缓存操作，避免修改或上传到一半的文件被缓存到内存中了。

#### opcache.lockfile_path

默认值：`opcache.lockfile_path=/tmp`，用来存储共享锁文件的绝对路径（仅适用于 *nix 操作系统）。
