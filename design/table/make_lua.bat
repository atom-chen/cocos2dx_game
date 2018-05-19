@echo off
::file path
for %%i in (%0) do set pt=%%~dpi
set OUTPUT_FILE_PATH=%pt%lua\
set XLSX_FILE_PATH=%pt%xlsx\

::delete lua file
del "%OUTPUT_FILE_PATH%\*" /f /s /q /a
Python27\python.exe excel2lua.py %XLSX_FILE_PATH% %OUTPUT_FILE_PATH%

rem for /r "%XLSX_FILE_PATH%" %%i in ("%FILE_TYPE%") do (
rem 	echo %%i
rem 	echo "%%~ni"
rem 	echo "%%~nxi"
rem 	echo "%OUTPUT_FILE_PATH%%%~nxi"
rem 	Python27\python.exe Python27\excel2lua.py %%i "%OUTPUT_FILE_PATH%%%~nxi"
rem )
