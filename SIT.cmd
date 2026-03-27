@echo off
chcp 65001>nul 2>&1
setlocal
setlocal enabledelayedexpansion

::set
set "home=%~dp0"
set "ver=1.0"
set "out=con"
for /f "tokens=4" %%a in ('chcp') do set c=%%a
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
	exit /b
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
	REM Cannot be used with -o.
	REM echo  ^| -o ^<output^> [-l] Also using in scripts. Forces output to ^<output^>. Cannot be user with -s.
	echo.>>%out%
	echo  - WMI:>>%out%
	echo  ^| wmi ^<alias^> - Displays already formatted wmic output.>>%out%
	echo  ^| Example: "sit wmi os" - displays already formatted OS info.>>%out%
	echo  ^| >>%out%
	echo  ^| To see all WMI aliases use "sit wmi -a".>>%out%
	echo  ^| You can also use "sit wmi <alias> get <alias_params_list>".>>%out%
	echo  ^| Where ^<alias_param_list^> is ^<params^> in "wmic <alias> get <params>".>>%out%
	echo  ^| Example: "sit wmi useraccount get name,sid".>>%out%
	echo  ^| ! ! ! OR you can also use "sit wmi <alias> set <property>=<value>">>%out%
	echo  ^| To see all writable properties, use "sit wmi <alias> -p">>%out%
	echo.>>%out%
	echo  - System Info:>>%out%
	echo  ^| systeminfo - Displays global info about your system.>>%out%
	echo ^|=========================^|>>%out%
	exit /b
)

if "%1"=="wmi" (
	if "%2"=="-a" (
		start cmd /k "wmic /?"
		echo WMI aliases displayed in new console window.>>%out%
		exit /b
	)
	if "%3"=="-p" (
		for /f "delims= skip=8" %%a in ('wmic %2 set /?') do echo  ^| %%a>>%out%
		exit /b
	)
	if "%2"=="" (
		goto wa
	)
	if "%3"=="get" (
		if "%4"=="" (
			goto wa
		)
		wmic %2 get %4 /format:value
		exit /b
	)
	if "%3"=="set" (
		if "%4"=="" (
			goto wa
		)
		wmic %2 set %4>>%out%
		exit /b
	)
	wmic %2 get /format:value>>%out%
	exit /b
)
if "%1"=="systeminfo" (
	if not "%2"=="" (
		goto wa
	)
	systeminfo>>%out%
	exit /b
)



:argsw
call :get_last_arg %args%
if "%lastArg%"=="-s" (
	set "out=nul"
	exit /b
)
if "%lastArg%"=="-o"
exit /b

:: USE: call :get_last_arg args
:get_last_arg

:loop_args
if "%~1"=="" goto :end_get_last_arg
set "lastArg=%~1"
shift
goto :loop_args
:end_get_last_arg
exit /b








:Aget_last_arg

:Aloop_args
if "%~1"=="" goto :Aend_get_last_arg
set "lastArg=%~1"
shift
goto :Aloop_args
:Aend_get_last_arg
exit /b







::wrong args
:wa
echo.>>%out%
echo Arguments are wrong!>>%out%
echo Need help? Use "sit help">>%out%
echo.>>%out%
exit /b