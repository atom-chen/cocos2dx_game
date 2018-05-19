@echo on

call make_lua.bat
XCOPY lua ..\..\program\client\game\src\Config\  /s  /e /y /d

pause