%INCLUDE "winAPI.inc"		;;Declare external procedure {winapi}
%INCLUDE "Console1.mac"		;;Macro definition

SEGMENT .DATA use32
Title   	db "ADDITION",0 

msg1 		db 13,10,13,10,"=> ",0
msg1_len 	dd $-msg1
msg2 		db 13,10,"=> ",0
msg2_len 	dd $-msg2
msg3 		db 13,10,"+ : ",0
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
Bil1		resd 1
Bil2		resd 1


SEGMENT .CODE use32
..start:

NewConsole 	Title, hStdOut, hStdIn

DisplayText	hStdOut, msg1, msg1_len, nBytes
GetText		hStdIn, buff, buff_len, iBytes

CMP dword [iBytes],2    ;; if just Enter (2 char) then Exit
JE  exit

CALL Str2Bil
MOV  [Bil1], EAX

DisplayText	hStdOut, msg2, msg2_len, nBytes
GetText		hStdIn, buff, buff_len, iBytes

CALL Str2Bil
MOV  [Bil2], EAX

ADD  EAX, [Bil1]									; EAX = Bil1 + Bil2

CALL Numeric2Str									; CONVERT TO STRING

DisplayText	hStdOut, msg3, msg3_len, nBytes
DisplayText	hStdOut, strhasil, str_len, nBytes		; DISPLAY RESULT

JMP ..start

exit: QuitConsole
	
RET

;=================================================================================================
; CONVERT string(buff) to NUMERIC  result in register EAX 
;-------------------------------------------------------------------------------------
Str2Bil:
        xor eax,eax			;set hasil = 0
        mov esi, 10			;pengali 10
        mov ebx, buff
	mov ecx, [iBytes]
	sub ecx, 2
	xor edx,edx
    Loopbil:
        mul esi 			;hasil sebelumnya * 10
        mov dl, byte [ebx]
        sub dl,30h 			;ubah ke 0-9
        add eax,edx 			;tambahkan dg digit terakhir 
        inc ebx
        loop Loopbil
    
ret

; CONVERT Numeric (EAX) TO STRING (strhasil) 
;-------------------------------------------------------------------------------------
Numeric2Str: 

	mov ebx, strhasil	;; hasil konversi disimpan di strhasil  
 
 loop1:				
	inc ebx			;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0		;; diposisikan pada akhir string strhasil 
	jne loop1		

	dec ebx

	mov si,10	      		
 loop2:				
	xor edx, edx		;; edx di-nolkan untuk menampung sisa bagi
	div si			;; dilakukan pembagian 10 berulang
	add dl, '0'        	;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl		;; simpan ke strhasil dari belakang ke depan
	dec ebx			;; majukan pointer
	or  eax,eax		;; test apakah yang dibagi sudah nol
	jnz loop2 		;; selesai perulangan jika yang dibagi sdh nol   
ret



