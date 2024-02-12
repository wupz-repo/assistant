@echo off

echo 1.Create Httpd Config
set assistant=%cd%
:xml
(
echo Define SRVROOT "%assistant%"
echo Include conf^/main.conf
)>conf/httpd.conf
echo.

echo 2.Create System Service
bin\httpd.exe -k install -n assistant
bin\httpd.exe -k start -n assistant
echo.