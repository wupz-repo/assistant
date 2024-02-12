@echo off

bin\httpd.exe -k stop -n assistant
bin\httpd.exe -k uninstall -n assistant

del /f conf\httpd.conf
del /f logs\*.log
echo.