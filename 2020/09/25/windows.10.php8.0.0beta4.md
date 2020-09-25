[返回主页](../../../README.md)

## 前言

在使用 `Visual Studio Code` 开发PHP的时候，语法总提示不对，因为当前处于 `Windows 10`下，PHP版本较老

对于一些新的语法无法提供支持，但是官方并没有提供 `php8.0.0.beta4` 的 `Windows` 版本，所以打算自己编译

参考：[PHP的官方编译教程](https://wiki.php.net/internals/windows/stepbystepbuild_sdk_2)

## 工具

[Visual Studio Community 2019](https://visualstudio.microsoft.com/zh-hans/vs/)

[PHP SDK](https://github.com/Microsoft/php-sdk-binary-tools)

[PHP 8.0.0beta4](https://github.com/php/php-src/releases)

在`Github`下载速度慢不说，很有可能失败只能重新下载，所以建议使用迅雷，偶尔会出现极速下载

`Visual Studio` 在安装的时候，需要勾选 `使用 C++ 的桌面开发`

如果忘记了，可以在开始菜单找到 `Visual Studio Installer` -> `更多` -> `修改`，重新勾选安装

## 编译

1. 在`PHP-SDK`文件夹下打开`phpsdk-vs16-x64.bat`，输入`phpsdk_buildtree php-dev`

    该命令将会创建一个`php-dev`的编译项目文件夹，并自动切换到该目录下

2. 将PHP的源代码解压并复制到`php-dev`文件夹下，例如：`E:\php-sdk\php-dev\vs16\x64\php-src-php-8.0.0beta4`

3. `cd php-src-php-8.0.0beta4`进入源代码目录，执行 `phpsdk_deps -u` 命令安装依赖，大概`有生之年里`会安装好

    速度慢可以通过高科技`github /freefq/free`或是人民币`google expressvpn`解决

    实在不行，可以把 所有 [依赖项目](https://windows.php.net/downloads/php-sdk/deps/vs16/x64/) 都下载到本地磁盘里，例如：`E:\php-sdk-deps\` 文件夹里

    然后打开 `PHP-SDK` 文件夹下的 `\lib\php\libsdk\SDK\Build\Dependency\Fetcher.php` 文件

    将`第43行`的 `$url = "{$this->scheme}://{$this->host}:{$this->port}$uri";`

    修改为：

    ```php
    if (substr($uri, -3) == 'zip') {
        $url = "file:///E:\\php-sdk-deps\\" . basename($uri);
    } else {
        $url = "{$this->scheme}://{$this->host}:{$this->port}$uri";
    }
    ```

    然后再次执行 `phpsdk_deps -u` 命令安装依赖，现在将会从本地磁盘中下载依赖文件

4. 执行 `buildconf` 命令，大概率会提示 `Rebuilding configure.js  Now run 'configure --help'`，可以不用管

5. 执行 `configure --disable-all  --enable-cli`，期间也会有一些意外的提示，不用管

6. 编译成功，生成的 `PHP` 目录在 `\x64\Release_TS` 目录下

## 结论

迷迷糊糊编译成功了，很多问题也搞不懂，但最终成功了，反正目的仅仅只是本地使用 `Visual Studio Code` 进行 `PHP` 开发的时候，不要提示语法错误就好了。