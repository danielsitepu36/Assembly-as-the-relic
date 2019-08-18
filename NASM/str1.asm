;include "win32.inc"

extern ExitProcess
extern AllocConsole 
extern FreeConsole 
extern SetConsoleTitleA 
extern Sleep 
extern GetStdHandle
extern ReadFile
extern WriteFile


import ExitProcess kernel32.dll
import AllocConsole kernel32.dll 
import FreeConsole kernel32.dll 
import SetConsoleTitleA kernel32.dll 
import Sleep kernel32.dll
import GetStdHandle  kernel32.dll
import ReadFile  kernel32.dll
import WriteFile  kernel32.dll


SEGMENT .DATA use32
judul   	db "HURUF BESAR",0 

msg 		db "TULIS KALIMAT:",0
msg_len 	db 15


buff		resb 255
buff_len	db 255


SEGMENT .BSS
hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1



SEGMENT .CODE use32
..start:

call [AllocConsole] 
	
push dword judul 
call [SetConsoleTitleA] 
	
push dword -11 			;; STD_OUTPUT_HANDLE = -11.
call [GetStdHandle] 
mov dword [hStdOut], eax 

push dword -10			;; STD_INPUT_HANDLE = -10 
call [GetStdHandle] 
mov dword [hStdIn], eax 

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg_len] 		;; parameter ke 3 panjang string
push dword msg			;; parameter ke 2 string yang akan ditampilkan "Tulis Kalimat : "
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 				

push dword 0 			;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 		;; parameter ke 4 jumlah byte yg sesungguhnya terbaca
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 		;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			

MOV ECX,iBytes
SUB ECX, 2

MOV EBX, dword buff

ups:
     mov al, byte [EBX]
     sub al,32
     mov byte [EBX], al

     INC EBX
     LOOP ups

ADD EBX,2
MOV byte [EBX],0


push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg_len] 		;; parameter ke 3 panjang string
push dword msg			;; parameter ke 2 string yang akan ditampilkan "Tulis Kalimat : "
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 				

push dword 0 			;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 		;; parameter ke 4 jumlah byte yg sesungguhnya terbaca
push dword [iBytes] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 		;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdOut] 		;; parameter ke 1 handle stdin
call [WriteFile] 			

        
push dword 10000 			;; delay 10 second 
call [Sleep] 

call [FreeConsole] 

	
push 0
call [ExitProcess]
leave
	
RET

