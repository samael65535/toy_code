@echo off
setlocal enabledelayedexpansion
set /a ext=0
set /a front=0
set /a ii=0
set /a loopCount=2
for /l %%i in (1,1,100) do (
       set /a ext=!ii!%%3+!loopCount!
       set /a front=!ii!/3+1
       set /a ii+=1
       if !front! LEQ 10 (  
          echo a_!ii!.txt "->" 15JX-JS_00!front!ext!.txt
          rename a_!ii!.txt 15JX-JS_0!front!_00!ext!.txt
       ) else (
          if !front! LEQ 100 (
		echo a_!ii!.txt "->"15JX-JS_0!front!_00!ext!.txt
                rename a_!ii!.txt 15JX-JS_0!front!_00!ext!.txt
          )
       )
)
pause