%INCLUDE "winAPI.inc"		;;Declare external procedure {winapi} in file winAPI.inc
%INCLUDE "Console.mac"		;;Declare MACRO in file Console.mac

SEGMENT .DATA use32
Title   	db "UPPERCASE CONVERSION",0 

msg1 		db 13,10,"WRITE TEXT (Quit Just Enter): ",0
msg1_len 	dd $-msg1
msg2 		db 13,10,"CONVERT TO UPCASE           : ",0
msg2_len 	dd $-msg2

buff		resb 255
buff_len	dd 255


SEGMENT .BSS  use32
hStdOut		resd 1 
hStdIn		resd 1 
nBytes		resd 1
iBytes		resd 1

SEGMENT .CODE use32
..start:

BuatConsole 	Title, hStdOut, hStdIn

ulangi:
TampilkanText	hStdOut, msg1, msg1_len, nBytes
BacaText	hStdIn, buff, buff_len, iBytes

CMP dword [iBytes],2    ;; Jika hanya ditekan Enter (2 char) maka Exit
JE  exit

MOV ECX, [iBytes]	;; iBytes menyimpan panjang string yang dituliskan, termasuk Enter (2 bytes: 13,10)
SUB ECX, 2
MOV EBX, dword buff

ups:
     SUB byte [EBX],32
     INC EBX
     LOOP ups


TampilkanText	hStdOut, msg2, msg2_len, nBytes
TampilkanText	hStdOut, buff, iBytes, nBytes

JMP ulangi

exit: 
TutupConsole
	
RET

