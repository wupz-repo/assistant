@echo off

mkdir temp
curl -o temp/httpd-2.4.57-win64-VS16.zip https://www.apachelounge.com/download/VS16/binaries/httpd-2.4.57-win64-VS16.zip
curl -o temp/php-8.1.27-Win32-vs16-x64.zip https://windows.php.net/downloads/releases/php-8.1.27-Win32-vs16-x64.zip
curl -o temp/php_yaf-3.3.4-8.1-ts-vs16-x64.zip https://windows.php.net/downloads/pecl/releases/yaf/3.3.4/php_yaf-3.3.4-8.1-ts-vs16-x64.zip
curl -o temp/php_yaml-2.2.2-8.1-ts-vs16-x64.zip https://windows.php.net/downloads/pecl/releases/yaml/2.2.2/php_yaml-2.2.2-8.1-ts-vs16-x64.zip
curl -o temp/php_mongodb-1.13.0-8.1-ts-vs16-x64.zip https://windows.php.net/downloads/pecl/releases/mongodb/1.13.0/php_mongodb-1.13.0-8.1-ts-vs16-x64.zip

unzip temp/httpd-2.4.57-win64-VS16.zip -d temp/httpd
unzip temp/php-8.1.27-Win32-vs16-x64.zip -d temp/php
unzip temp/php_yaf-3.3.4-8.1-ts-vs16-x64.zip -d temp/php_yaf
unzip temp/php_yaml-2.2.2-8.1-ts-vs16-x64.zip -d temp/php_yaml
unzip temp/php_mongodb-1.13.0-8.1-ts-vs16-x64.zip -d temp/php_mongodb

del /f release/bin/.gitkeep
del /f release/logs/.gitkeep
del /f release/modules/.gitkeep
del /f release/php_ext/.gitkeep

cp temp/httpd/Apache24/bin/httpd.exe release/bin/
cp temp/httpd/Apache24/bin/libapr-1.dll release/bin/
cp temp/httpd/Apache24/bin/libapriconv-1.dll release/bin/
cp temp/httpd/Apache24/bin/libaprutil-1.dll release/bin/
cp temp/httpd/Apache24/bin/libhttpd.dll release/bin/
cp temp/httpd/Apache24/bin/pcre2-8.dll release/bin/

cp temp/httpd/Apache24/modules/mod_authz_core.so release/modules/
cp temp/httpd/Apache24/modules/mod_autoindex.so release/modules/
cp temp/httpd/Apache24/modules/mod_dir.so release/modules/
cp temp/httpd/Apache24/modules/mod_log_config.so release/modules/
cp temp/httpd/Apache24/modules/mod_mime.so release/modules/
cp temp/httpd/Apache24/modules/mod_rewrite.so release/modules/
cp temp/httpd/Apache24/modules/mod_ssl.so release/modules/
cp temp/httpd/Apache24/conf/mime.types release/conf/

cp temp/php/php8apache2_4.dll release/bin/
cp temp/php/php8ts.dll release/bin/
cp temp/php/ext/*.dll release/php_ext/
cp temp/php_yaf/php_yaf.dll release/php_ext/
cp temp/php_yaml/php_yaml.dll release/php_ext/
cp temp/php_mongodb/php_mongodb.dll release/php_ext/

:xml
(
echo ServerRoot "${SRVROOT}"
echo.
echo LoadModule authz_core_module modules/mod_authz_core.so
echo LoadModule log_config_module modules/mod_log_config.so
echo LoadModule rewrite_module modules/mod_rewrite.so
echo LoadModule dir_module modules/mod_dir.so
echo LoadModule mime_module modules/mod_mime.so
echo LoadModule php_module bin/php8apache2_4.dll
echo.
echo AddHandler application/x-httpd-php .php
echo PHPIniDir "${SRVROOT}/conf"
echo.
echo Listen 8800
echo ServerName localhost
echo ServerAdmin ap@ipsni.eu.org
echo.
echo ServerTokens Prod
echo ServerSignature Off
echo.
echo ErrorLog "${SRVROOT}/logs/ap-httpd-error.log"
echo LogLevel emerg
echo.
echo ^<IfModule log_config_module^>
echo     LogFormat ^"%h %l %u %t \^"%r\" %^>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
echo     LogFormat ^"%h %l %u %t \^"%r\" %^>s %b" common
echo     ^<IfModule logio_module^>
echo         LogFormat ^"%h %l %u %t \"%r\" %^>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O^" combinedio
echo     ^</IfModule^>
echo     CustomLog "${SRVROOT}/logs/ap-httpd-access.log" common
echo ^</IfModule^>
echo.
echo ^<VirtualHost 0.0.0.0:8800^>
echo     DocumentRoot "${SRVROOT}/htdocs/public"
echo     DirectoryIndex index.php
echo     ^<Directory "${SRVROOT}/htdocs/public"^>
echo         Options Indexes FollowSymLinks MultiViews
echo         AllowOverride All
echo     ^</Directory^>
echo     ErrorLog "${SRVROOT}/logs/ap-web-error.log"
echo     CustomLog "${SRVROOT}/logs/ap-web-access.log" common
echo ^</VirtualHost^>
)>release/conf/main.conf

:xml
(
echo [PHP]
echo expose_php = Off
echo.
echo extension_dir="..\\php_ext"
echo extension=bz2
echo extension=com_dotnet
echo extension=curl
echo extension=fileinfo
echo extension=gd
echo extension=yaf
echo extension=yaml
echo extension=sqlite3
echo extension=pdo_sqlite
echo extension=openssl
echo extension=intl
echo extension=mbstring
echo extension=mongodb
echo.
echo [yaf]
echo yaf.use_namespace=1
echo yaf.use_spl_autoload=1
)>release/conf/php-apache2handler.ini
