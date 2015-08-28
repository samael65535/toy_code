@echo off
setlocal enabledelayedexpansion
set /a ext=0
set /a front=0
set /a ii=0
:: 重命名周期
set /a loopCount=2
for /l %%i in (1,1,99) do (
       set /a ext=!ii!%%!loopCount!+!loopCount!
       set /a front=!ii!/!loopCount!+1
       set /a ii+=1
       if !front! LSS 10 (
	   	  :: 重命名
		  if !ii! LSS 10 (
		  		 echo a_0!ii!.txt "->" 15JX-JS_00!front!_0!ext!.txt
			     rename a_0!ii!.txt 15JX-JS_00!front!_0!ext!.txt
		  ) else (
		  		  echo a_!ii!.txt "->" 15JX-JS_00!front!_0!ext!.txt
	              rename a_!ii!.txt 15JX-JS_00!front!_0!ext!.txt
		  )
       ) else (
          if !front! LSS 100 (
		        :: 重命名
		  		if !ii! LSS 10 (
		  		  	 echo a_0!ii!.txt "->" 15JX-JS_0!front!_0!ext!.txt
					 rename a_0!ii!.txt 15JX-JS_0!front!_0!ext!.txt
				) else (
		  		  echo a_!ii!.txt "->" 15JX-JS_0!front!_0!ext!.txt
	              rename a_!ii!.txt 15JX-JS_0!front!_0!ext!.txt
	  		    )
          )
       )
)
pause
