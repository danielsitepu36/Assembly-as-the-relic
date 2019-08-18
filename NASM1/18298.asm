%INCLUDE "winAPI.inc" ;;Declare external procedure {winapi} in file winAPI.inc

SEGMENT .DATA use32
Title   	db "18298 - Muhammad Naufal",0 

msg1 		db 13,10,"Tulis kalimat (press enter to exit): ",0
msg1_len 	dd $-msg1

msg2 		db 13,10,"Uppercase: ",0
msg2_len 	dd $-msg2

msg3 		db 13,10,"Banyak kata: ",0
msg3_len 	dd $-msg3

msg4 		db 13,10,"Banyak karakter (tidak termasuk spasi): ",0
msg4_len 	dd $-msg4

msg5 		db 13,10,"Kalimat yang dibalik: ",0
msg5_len 	dd $-msg5

buff		resb 255
buff_len	dd 255

rev		resb 255
rev_len	dd 255

words		resb 255
words_len	dd 10

char		resb 255
char_len	dd 10

SEGMENT .BSS  use32
hStdOut		resd 1 
hStdIn		resd 1 
nBytes		resd 1
iBytes		resd 1



SEGMENT .CODE use32
..start:

call [AllocConsole] 
push dword Title 
call [SetConsoleTitleA] 
	
push dword -11 			;; STD_OUTPUT_HANDLE = -11.
call [GetStdHandle] 
mov dword [hStdOut], eax 

push dword -10			;; STD_INPUT_HANDLE = -10 
call [GetStdHandle] 
mov dword [hStdIn], eax 

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg1_len] 	;; parameter ke 3 panjang string
push dword msg1			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 				

push dword 0 			;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 		;; parameter ke 4 jumlah byte yg sesungguhnya terbaca
push dword [buff_len] 	;; parameter ke 3 panjang buffer yg disediakan
push dword buff 		;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 	;; parameter ke 1 handle stdin
call [ReadFile] 

CMP dword [iBytes],2    ;; Jika hanya ditekan Enter (2 char) maka Exit
JE  exit			

MOV ECX, [iBytes]		;; iBytes menyimpan panjang string yang dituliskan, termasuk Enter (2 bytes: 13,10)
SUB ECX, 2

MOV byte [words], 1
MOV byte [char], 0
MOV EBX, dword buff
SUB EDX, EDX
SUB EDI, EDI

; Convert to uppercase start
ups:
	 cmp byte [EBX], 97
	 jl notword
	 cmp byte [EBX], 122
	 jg notword
	 SUB byte [EBX],32
	 notword:
	 	cmp byte [EBX], 32
	 	jne notspace
	 	INC EDX
	 	notspace:
     		INC EBX
     		INC EDI
     LOOP ups

ADD EBX,2
MOV byte [EBX], 0	
; Convert to uppercase end
; gatau males pengen beli trek
; Count word and character start
MOV ESI, EDX
ADD ESI, 1
SUB EDI, EDX
; MOV dword [char], EDI
; MOV dword [words], ESI
MOV EDI, dword char
MOV ESI, dword words
; ADD dword [ESI], 48
; ADD dword [EDI], 48

; start test algorithm convert string

; end test convert string

; Count word and character end
	
; Print uppercase start
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg2_len] 	;; parameter ke 3 panjang string
push dword msg2			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 				

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 	;; parameter ke 3 panjang string
push dword buff			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 				
; print uppercase end

; Print message 5 start
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg5_len] 	;; parameter ke 3 panjang string
push dword msg5			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 
; Print message 5 end

; Reverse start
MOV ECX, [iBytes]
SUB ECX, 2
MOV EAX, dword buff
MOV ESI, EAX
ADD EAX, ECX
MOV EDI, EAX
DEC EDI
SHR ECX, 1
jz done
reverse:
	MOV AL, byte [ESI]
	MOV BL, byte [EDI]
	MOV byte [ESI], BL 
	MOV byte [EDI], AL
	inc ESI
	dec EDI
	dec ECX
	jnz reverse
;Reverse end

done:
; Print reversed start
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 	;; parameter ke 3 panjang string
push dword buff			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 		
; print reversed end

; Print jumlah karakter & kata start
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg4_len] 	;; parameter ke 3 panjang string
push dword msg4			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [char_len] 	;; parameter ke 3 panjang string
push dword char		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg3_len] 	;; parameter ke 3 panjang string
push dword msg3			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 	      

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [words_len] 	;; parameter ke 3 panjang string
push dword words		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]
; print jumlah karakter dan kata end

jmp ..start	;looping agar dapat input string baru

exit: 
push 0
call [ExitProcess]
leave

RET

