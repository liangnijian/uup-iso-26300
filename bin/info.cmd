set build=%~1
set "uupurl=https://api.uupdump.net/listid.php?search=%build%&sortByDate=1"

set "condition=title=Windows.*version.*build=.*%build%.*%arch%"
if "%build%"=="17763" set "condition=Feature.*version.1809.*build=.*%build%.*%arch%"
if "%build%"=="19044" set "condition=Feature.*version.21h2.*build=.*%build%.*%arch%"
if "%build%"=="19045" set "condition=Feature.*version.22h2.*build=.*%build%.*%arch%"
if "%build%"=="22000" set "condition=title=Windows.11.*build=.*%build%.*%arch%"
if "%build%"=="22621" set "condition=title=Windows.11,.*version.22h2.*build=.*%build%.*%arch%"
if "%build%"=="22631" set "condition=title=Windows.11,.*version.23h2.*build=.*%build%.*%arch%"
if "%build%"=="26100" set "condition=title=Windows.11,.*version.24h2.*build=.*%build%.*%arch%"
if "%build%"=="26200" set "condition=title=Windows.11,.*version.25h2.*build=.*%build%.*%arch%"
if "%build%"=="28000" set "condition=title=Windows.11,.*version.26h1.*build=.*%build%.*%arch%"
if "%build%"=="26300" set "condition=title=Windows.11,.*version.26h2.*build=.*%build%.*%arch%"

:readID
cls
echo 正在查询 %build% %arch% 的信息……
timeout /t 5 /nobreak

for /f "delims=" %%a in ('powershell -command "Invoke-RestMethod -Uri '%uupurl%' | ConvertTo-Json" ^| findstr /i "%condition%"') do (
	set uuid=%%a
	goto :findinfo
)

:findinfo
set updateTitle=
set foundBuild=
set updateId=
for /f "tokens=2 delims={}" %%b in ("!uuid!") do (
	for /f "tokens=2,4,10 delims=;=" %%c in ("%%b") do (
		set updateTitle=%%c
		set foundBuild=%%d
		set updateId=%%e
	)
)
if "%updateId%"=="" goto :readID
