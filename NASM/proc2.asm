;include "win32.inc"

extern ExitProcess
extern AllocConsole 
extern FreeConsole 
extern SetConsoleTitleA 
extern Sleep 

import ExitProcess kernel32.dll
import AllocConsole kernel32.dll 
import FreeConsole kernel32.dll 
import SetConsoleTitleA kernel32.dll 
import Sleep kernel32.dll

SEGMENT .DATA use32
data1 dd 0005
data2 dd 0015
hasil dd 0
judul db "INI HEADER CONSOLE",0

SEGMENT .CODE use32
..start:

	call [AllocConsole] 
	
	push dword judul 
	call [SetConsoleTitleA] 
	
	PUSH DWORD [data1]
	PUSH DWORD [data2]

	;CALL [tambahkan]

        POP DWORD [hasil]

	push dword 10000 			;; delay 10 second 
	call [Sleep] 

	call [FreeConsole] 

	
	push 0
	call [ExitProcess]
	leave
	
RET

tambahkan:
	
	POP EBX
	POP EAX	
	ADD EAX, EBX
	PUSH EAX
        RET