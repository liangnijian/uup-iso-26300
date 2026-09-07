@echo off

tzutil /s "UTC"

for /f %%i in ('powershell -command "& { $today=Get-Date; $firstOfMonth=Get-Date -Year $today.Year -Month $today.Month -Day 1; $firstTuesday=$firstOfMonth; while ($firstTuesday.DayOfWeek -ne 'Tuesday') { $firstTuesday=$firstTuesday.AddDays(1) }; $secondTuesday=$firstTuesday.AddDays(7); $today.Date -eq $secondTuesday.Date }"') do set "result=%%i"
if "%result%"=="False" (
	echo 不是本月的第二个星期二
	exit /b 1
)

call uup-iso.cmd
