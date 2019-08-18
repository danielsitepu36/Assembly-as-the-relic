%INCLUDE "winAPI.inc"		;;Declare external procedure {winapi} in file winAPI.inc
%INCLUDE "Console.mac"		;;Declare MACRO in file Console.mac

SEGMENT .DATA use32
Title   	db "UPPERCASE AND TEXT LENGTH",0 

msg1 		db 13,10,13,10,"WRITE TEXT (Quit Just Enter): ",0
msg1_len 	dd $-msg1
msg2 		db 13,10,"CONVERT TO UPCASE           : ",0
msg2_len 	dd $-msg2
msg3 		db 13,10,"TEXT LENGTH                 : ",0
msg3_len 	dd $-msg3

buff		resb 255
buff_len	dd 255

strhasil	db '      ',0
str_len		db 6   


SEGMENT .BSS  use32
hStdOut		resd 1 
hStdIn		resd 1 
nBytes		resd 1
iBytes		resd 1

SEGMENT .CODE use32
..start:

BuatConsole 	Title, hStdOut, hStdIn
TampilkanText	hStdOut, msg1, msg1_len, nBytes
BacaText	hStdIn, buff, buff_len, iBytes

CMP dword [iBytes],2    ;; Jika hanya ditekan Enter (2 char) maka Exit
JE  exit

CALL UbahKeBesar
TampilkanText	hStdOut, msg2, msg2_len, nBytes
TampilkanText	hStdOut, buff, iBytes, nBytes

CALL Numeric2Str
TampilkanText	hStdOut, msg3, msg3_len, nBytes
TampilkanText	hStdOut, strhasil, str_len, nBytes

JMP ..start

exit: 
TutupConsole
	
RET

UbahKeBesar:

	MOV ECX, [iBytes]		;; iBytes menyimpan panjang string yang dituliskan, termasuk Enter (2 bytes: 13,10)
	SUB ECX, 2
	MOV EBX, dword buff

	ups:
		 SUB byte [EBX],32
		 INC EBX
		 LOOP ups

	ADD EBX,2
	MOV byte [EBX],0		;; text yang akan ditampilkan diakhiri dengan 0 

RET

; CONVERT Numeric (iBytes) TO STRING (strhasil) 
;-------------------------------------------------------------------------------------
Numeric2Str: 

	mov ebx, strhasil	;; hasil konversi disimpan di strhasil  
 
 loop1:				
	inc ebx				;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0		;; diposisikan pada akhir string strhasil 
	jne loop1		
	dec ebx
        		
				
	mov eax, [iBytes]	;; panjang string yang dibaca termasuk cr,lf
	sub eax, 2			;; maka panjangnya dikurangi cr,lf (2)
	mov si,10	

 loop2:				
	xor edx, edx		;; edx di-nolkan untuk menampung sisa bagi
	div si				;; dilakukan pembagian 10 berulang
	add dl, '0'        	;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl		;; simpan ke strhasil dari belakang ke depan
	dec ebx				;; majukan pointer
	or  eax,eax			;; test apakah yang dibagi sudah nol
	jnz loop2 			;; selesai perulangan jika yang dibagi sdh nol   
    
 stop:
RET
