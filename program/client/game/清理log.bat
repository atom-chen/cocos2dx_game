@echo off
::����Ŀ���ļ���
set m=log

del "%m%\*" /f /s /q /a
for /f "delims=" %%i in ('dir /ad /w /b "%m%"') do (
rd /s /q "%m%\%%i"
)