@echo off
setlocal
setlocal enabledelayedexpansion

::set
for /f "tokens=4" %%a in ('chcp') do set c=%%a
::IMP!!
chcp 65001>nul 2>&1
::IMP!!
set "home=%~dp0"
set "ver=1.0"
set "out=con"
set "args=%*"
set "SITReq=%0"
set "lastArg="

call :argsw

::no args
:na
if "%args%"=="" (
	call :head
	echo.	
	echo No arguments detected!
	echo Need help? Use "sit help"
	echo.
	goto exit
)




::launch

goto main



::header
:head
echo ^|=========================^|>>%out%
echo ^|  System Info Tool v%ver%  ^|>>%out%
echo ^|=========================^|>>%out%
echo.>>%out%
echo Request: "%SITReq% %args%">>%out%
echo.>>%out%
exit /b



:main
call :head
if "%1"=="help" (
	echo ^|=========================^|>>%out%
	echo  - SIT syntax:>>%out%
	echo  ^| SIT ^<sit_command^> ^<arguments^>.>>%out%
	echo ^|=========================^|>>%out%
	echo  - Arguments:>>%out%
	echo  ^| -s Using in scripts. Disables console output.>>%out%
	echo  ^| ^| Cannot be used with -o.
	echo  ^| -o ^<output^> Also using in scripts. Forces output to ^<output^>. Cannot be user with -s.
	echo.>>%out%
	echo ^|=========================^|>>%out%
	echo  - SIT commands:>>%out%
	echo  ^|
	echo  ^|  - WMI:>>%out%
	echo  ^|  ^| wmi ^<alias^> - Displays formatted wmic output.>>%out%
	echo  ^|  ^| Example: "sit wmi os" - displays formatted OS info.>>%out%
	echo  ^|  ^| >>%out%
	echo  ^|  ^| To see all WMI aliases use "sit wmi -a".>>%out%
	echo  ^|  ^| You can also use "sit wmi <alias> get <alias_params_list>".>>%out%
	echo  ^|  ^| Where ^<alias_param_list^> is ^<params^> in "wmic <alias> get <params>".>>%out%
	echo  ^|  ^| Example: "sit wmi useraccount get name,sid".>>%out%
	echo  ^|  ^| ! ! ! OR you can also use "sit wmi <alias> set <property>=<value>">>%out%
	echo  ^|  ^| To see all writable properties, use "sit wmi <alias> -p">>%out%
	echo  ^|>>%out%
	echo  ^|  - System Info:>>%out%
	echo  ^|  ^| systeminfo - Displays global info about your system.>>%out%
	echo ^|=========================^|>>%out%
	goto exit
)

if "%1"=="wmi" (
	if "%2"=="-a" (
		start cmd /k "wmic /?"
		echo WMI aliases displayed in new console window.>>%out%
		goto exit
	)
	if "%3"=="-p" (
		for /f "delims= skip=8" %%a in ('wmic %2 set /?') do echo  ^| %%a>>%out%
		goto exit
	)
	if "%2"=="" (
		goto wa
	)
	if "%3"=="get" (
		if "%4"=="" (
			goto wa
		)
		wmic %2 get %4 /format:value
		goto exit
	)
	if "%3"=="set" (
		if "%4"=="" (
			goto wa
		)
		wmic %2 set %4>>%out%
		goto exit
	)
	wmic %2 get /format:value>>%out%
	goto exit
)
if "%1"=="systeminfo" (
	if not "%2"=="" (
		goto wa
	)
	systeminfo>>%out%
	goto exit
)
goto wa


::ARGUMENTS WORKER
:argsw
for /f "usebackq delims=" %%a in (`call %this%argsw.cmd 1 %args%`) do set "argswres=%%a"
if "%argswres%"=="-s" (
	set "out=nul"
	exit /b
)
for /f "usebackq delims=" %%a in (`call %this%argsw.cmd 2 %args%`) do set "argo1=%%a"
for /f "usebackq delims=" %%a in (`call %this%argsw.cmd 1 %args%`) do set "argo2=%%a"
if "%argo1%"=="-o" (
	set "out=%argo2%"
	exit /b
)
exit /b


::EXIT
:exit
chcp %c%>nul 2>&1
endlocal
exit /b



::wrong args
:wa
echo.>>%out%
echo Arguments are wrong!>>%out%
echo Need help? Use "sit help">>%out%
echo.>>%out%
goto exit
