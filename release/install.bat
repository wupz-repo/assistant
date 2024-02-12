@echo off

echo 1.Create Httpd Config
set ap=%cd%
:xml
(
echo Define SRVROOT "%ap%"
echo Include conf^/main.conf
)>conf/httpd.conf
echo.

echo 2.Create System Service
bin\httpd.exe -k install -n ap_httpd
bin\httpd.exe -k start -n ap_httpd
echo.