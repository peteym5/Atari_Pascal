REM Pascal Switches
REM -d: address diagnostic mode
REM  -code: $ address start address of the program
REM  -data: $ address memory address for variables, arrays
REM  -stack: $ address memory address for the software stack (64 bytes)
REM  -page: $ address address on the zero page for variables (24 bytes)

setlocal

set PATH=E:\"Mad Pascal";E:\"Mad Pascal"\base;%PATH%

REM set PATH=\"Mad Pascal"\Base

mp.exe e:\"Mad Pascal"\"Mind Field"\"Mind Field.pas" -code:$8000 -data:$A000 -stack:$2C00 -zpage:$00A0

REM -code:$8000 -data:$2000 -stack:$2C00 -page:$A0

mads.exe e:\"Mad Pascal"\"Mind Field"\"Mind Field.a65" -o:"Mind Field.xex" -l:__MindField.txt

REM rename Splash_Title.obx Splash_Title.xex

pause
