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

设置该选项后，PHP中所有文件操作都将被限制在该目录下，当你准备将服务器上某个目录提供给他人使用时，该选项最有意义

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

在编译特殊的字符编码源文件时，该选项和 `zend.multibyte` 必须有一个开启了

### zend.exception_ignore_args = On
### zend.exception_string_param_max_len = 0