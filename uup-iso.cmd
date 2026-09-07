@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
set "PATH=%cd%\bin;%PATH%"

if exist "%~dp0uup_file" rd /s /q "%~dp0uup_file"
md "%~dp0uup_file"

set sysver=26300
set arch=amd64
set lang=zh-cn
set start-time=%time%
call :start %sysver%

echo 完成
echo 开始时间：%start-time%
echo 结束时间：%time%
rem pause
goto :EOF

:start
call info.cmd %~1
call filename.cmd
call download.cmd "%cd%\uup_file\%filename%"

cls
md "%~dp0uup_file\%filename:~0,-4%"
7z.exe x "%~dp0uup_file\%filename%" -y -o"%~dp0uup_file\%filename:~0,-4%"

rem 修改配置文件
if exist "%~dp0uup_file\ConvertConfig.ini" del /q "%~dp0uup_file\ConvertConfig.ini">>nul
for /f "delims=" %%i in (%~dp0uup_file\%filename:~0,-4%\ConvertConfig.ini) do (
	set content=%%i
	if "!content!"=="Cleanup      =0" set "content=Cleanup      =1"
	if "!content!"=="StartVirtual =0" set "content=StartVirtual =1"
	if "!content!"=="vAutoEditions=" set "content=vAutoEditions=Enterprise"
	echo !content!>>"%~dp0uup_file\ConvertConfig.ini"
)
copy /Y "%~dp0uup_file\ConvertConfig.ini" "%~dp0uup_file\%filename:~0,-4%\ConvertConfig.ini"
if exist "%~dp0uup_file\ConvertConfig.ini" del /q "%~dp0uup_file\ConvertConfig.ini">>nul

rem 执行 uup 脚本
cls
pushd "%~dp0%filename:~0,-4%"
echo 0|call "%~dp0uup_file\%filename:~0,-4%\uup_download_windows.cmd"
popd

for %%i in (%~dp0uup_file\%filename:~0,-4%\*.iso) do move /y "%%i" "%~dp0%%~nxi"

rd /s /q "%~dp0uup_file\%filename:~0,-4%"
del /f /a /q "%~dp0uup_file\%filename%"
goto :EOF
