taskkill /f /im game.exe
for %%i in (%0) do set pt=%%~dpi
cd /d %pt%
start simulator\win32\game.exe -workdir %pt%