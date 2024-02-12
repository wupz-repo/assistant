@echo off

bin\httpd.exe -k stop -n ap_httpd
bin\httpd.exe -k uninstall -n ap_httpd

del /f conf\httpd.conf
del /f logs\*.log
echo.