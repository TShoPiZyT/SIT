@echo off
setlocal enabledelayedexpansion
set "N=%1"
set count=0
for %%A in (%*) do (
    set /a count+=1
)
set /a targetIndex=%count% - %N%
set index=0
for %%A in (%*) do (
    if not "%%A"=="%1" (
        set /a index+=1
        if !index! EQU %targetIndex% (
            echo %%A
        )
    )
)
exit /b
