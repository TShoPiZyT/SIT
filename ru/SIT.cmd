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
	echo Нет аргуметнов!
	echo Нужна помощь? Используйте "sit help"
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
echo Запрос: "%SITReq% %args%">>%out%
echo.>>%out%
exit /b



:main
call :head
if "%1"=="help" (
	echo ^|=========================^|>>%out%
	echo  - Синтаксис SIT:>>%out%
	echo  ^| SIT ^<команда_SIT^> ^<аргументы^>.>>%out%
	echo ^|=========================^|>>%out%
	echo  - Аргументы:>>%out%
	echo  ^| -s Отключает вывод.>>%out%
	echo  ^| ^| Не может юыть использованно вместе с -o.
	echo  ^| -o ^<вывод^> Переводит вывод команды в ^<вывод^>. Не может быть использованно с -s.
	echo.>>%out%
	echo ^|=========================^|>>%out%
	echo  - Команды SIT:>>%out%
	echo  ^|
	echo  ^|  - WMI:>>%out%
	echo  ^|  ^| wmi ^<псевдоним^> - Форматирует вывод команды wmic.>>%out%
	echo  ^|  ^| Пример: "sit wmi os" - Выводит отформатированную информацию из псевдонима os.>>%out%
	echo  ^|  ^| >>%out%
	echo  ^|  ^| Чтобы показать все псевдонимы используйте "sit wmi -a".>>%out%
	echo  ^|  ^| Вы можете также использовать "sit wmi <псевдоним> get <список_параметров_псевдонимов>".>>%out%
	echo  ^|  ^| Где ^<список_параметров псевдонимов^> это ^<параметры^> d "wmic <псевдоним> get <параметры>".>>%out%
	echo  ^|  ^| Пример: "sit wmi useraccount get name,sid".>>%out%
	echo  ^|  ^| ^! ^! ^! ИЛИ вы можете также использовать "sit wmi <псевдоним> set <свойство>=<значение>">>%out%
	echo  ^|  ^| Чтобы посмотреть все свойства которые можно перезаписать, используйте "sit wmi <псевдоним> -p">>%out%
	echo  ^|>>%out%
	echo  ^|  - System Info:>>%out%
	echo  ^|  ^| systeminfo - Отоброжает общие сведения о системе.>>%out%
	echo ^|=========================^|>>%out%
	goto exit
)

if "%1"=="wmi" (
	if "%2"=="-a" (
		start cmd /k "wmic /?"
		echo Псевдонимы отображены в новом окне.>>%out%
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
echo Аргументы указаны неверно!>>%out%
echo Нужна помощь? Используйте "sit help">>%out%
echo.>>%out%
goto exit
