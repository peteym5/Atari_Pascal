REM Pascal Switches
REM -d: address diagnostic mode
REM  -code: $ address start address of the program
REM  -data: $ address memory address for variables, arrays
REM  -stack: $ address memory address for the software stack (64 bytes)
REM  -page: $ address address on the zero page for variables (24 bytes)
 
setlocal

set PATH=%PATH%;e:\"Mad Pascal";e:\"Mad Pascal"\lib;e:\"Mad Pascal"\blibs;e:\"Mad Pascal"\base

mp "Mind Field.pas" -code:$8000 -data:$A000 -stack:$80 -zpage:$C0

mads.exe e:\"Mad Pascal"\"Mind Field"\"Mind Field.a65" -i:..\base-rom -x -o:"Mind Field.xex" -l:__MindField.txt

pause
