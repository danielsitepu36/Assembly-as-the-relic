%INCLUDE "winAPI.inc"		;;Declare external procedure {winapi}
%INCLUDE "Console.mac"		;;Macro definition

SEGMENT .DATA use32
Title   	db "MIKROPROSESOR DANIEL - 18290",0 

msg0 		db 13,10,"---Daniel Suranta S / 18-424185-PA-18290---",0
msg0_len 	dd $-msg0
deco		db 13,10,"===========================================",0
deco_len	dd $-deco
msgout 		db 13,10,"Tekan ENTER untuk keluar dari program !",0
msgo_len 	dd $-msgout
msg1 		db 13,10,"Angka pertama     =>",0
msg1_len 	dd $-msg1
msg2 		db "Angka kedua       =>",0
msg2_len 	dd $-msg2
msg3 		db 13,10,"Masukkan Operasi, Untuk pengurangan hasil bisa negatif, pembagian termasuk hasil dan sisa bagi(modulo)",0
msg3_len 	dd $-msg3
msg4 		db 13,10,"Operasi (+,-,*,/) => ",0
msg4_len 	dd $-msg4
wrong 		db 13,10,"Input yang anda masukkan salah !",13,10,0
wrong_len 	dd $-wrong
msg5 		db 13,10,"Hasil perhitungan => ",0
msg5_len 	dd $-msg5
msg6 		db 13,10,13,10,"TERIMA KASIH",13,10,0
msg6_len 	dd $-msg6
msgdiv1		db 13,10,"Hasil pembagian   => ",0
msgd1_len 	dd $-msgdiv1
msgdiv2		db 13,10,"Sisa pembagian    => ",0
msgd2_len 	dd $-msgdiv2

op          resb 255
op_len      dd 255

buff		resb 255
buff_len	dd 255

strhasil	db '      ',0
str_len		db 6   


SEGMENT .BSS  use32
hStdOut		resd 1 
hStdIn		resd 1 
nBytes		resd 1
iBytes		resd 1
oBytes      resd 1
Bil1		resd 1
Bil2		resd 1


SEGMENT .CODE use32
..start:

BuatConsole 	Title, hStdOut, hStdIn

TampilkanText	hStdOut, deco, deco_len, nBytes
TampilkanText	hStdOut, msg0, msg0_len, nBytes
TampilkanText	hStdOut, deco, deco_len, nBytes


TampilkanText	hStdOut, msgout, msgo_len, nBytes
TampilkanText	hStdOut, msg1, msg1_len, nBytes
BacaText		hStdIn, buff, buff_len, iBytes

CMP dword [iBytes],2    ;; if just Enter (2 char) then Exit
JE  exit

CALL Str2Bil
MOV  [Bil1], EAX

TampilkanText	hStdOut, msg2, msg2_len, nBytes
BacaText		hStdIn, buff, buff_len, iBytes

CALL Str2Bil
MOV  [Bil2], EAX

INPUT:
    TampilkanText	hStdOut, msg3, msg3_len, nBytes
    TampilkanText	hStdOut, msg4, msg4_len, nBytes
    BacaText		hStdIn, op, op_len, oBytes              ;Membaca operator

    mov ECX,op

    cmp byte [ECX],43                       ;Jika '+' jump ke PLUS
    je PLUS
    cmp byte [ECX],45                       ;Jika '-' jump ke MINUS
    je MINUS
    cmp byte [ECX],42                       ;Jika '*' jump ke MINUSS
    je TIMESS
    cmp byte [ECX],47                       ;Jika '/' jump ke DIVIDE
    je DIVIDE

    TampilkanText	hStdOut, wrong, wrong_len, nBytes
    jmp INPUT

PLUS:
    mov EAX, [Bil2]
    add EAX, [Bil1]                         ;Tambahkan Bil1 ke EAX (Bil2), hasil di EAX
    CALL Numeric2Str
    jmp HASIL

MINUS:
    mov EAX, [Bil1]
    cmp EAX, [Bil2]
    jg POS                                  ;Apabila bil1>bil2, jump ke POS (hasil positif)
    mov EAX, [Bil2]
    mov EBX, [Bil1]
    sub EAX, EBX                            ;Jika bil1<bil2, kurangi bil2 dengan bil1
    CALL Numeric2StrNEG                     ;Hasil di EAX, konversi khusus hasil negatif
    jmp HASIL
    POS:
        mov EBX, [Bil2]
        sub EAX, EBX                        ;Jika positif kurangi bil1 dengan bil2
        CALL Numeric2Str                    ;Hasil di EAX, konversi seperti biasa
        jmp HASIL

TIMESS:
    xor EDX,EDX                             ;Kosongkan EDX
    mov EAX,[Bil2]
    mov EBX, [Bil1]
    mul EBX                                 ;Kali EAX(bil1) dengan EBX(bil2), hasil pada EAX
    xor EDX,EDX                             ;Kosongkan EDX
    CALL Numeric2Str		                ;Konversi EAX ke String
    jmp HASIL

DIVIDE:
    xor EDX,EDX                             ;Kosongkan EDX
    mov EAX, [Bil1]
    mov EBX, [Bil2]
    div EBX                                 ;Bagi EAX(bil1) dengan EBX(bil2), hasil pada EAX
    xor EDX,EDX                             ;Kosongkan EDX
    CALL Numeric2Str                        ;Konversi dan tampilkan EAX (Hasil Bagi)
    TampilkanText	hStdOut, msgdiv1, msgd1_len, nBytes
    TampilkanText	hStdOut, strhasil, str_len, nBytes
    xor EDX,EDX
    mov EAX, [Bil1]                         ;Ulangi proses untuk mendapatkan sisa bagi
    mov EBX, [Bil2]
    div EBX
    cmp EDX,0                               ;Jika sisa bagi 0, EAX akan diisi '0'
    jne NOTZERO             
    mov EAX,0
    jmp NEXTDIV
        NOTZERO:
        mov EAX,EDX                         ;Jika sisa bagi tidak 0, EAX akan diisi EDX (sisa pembagian)
    NEXTDIV:
    xor EDX,EDX                             ;Kosongkan EDX
    CALL Numeric2Str                        ;Konversi dan tampilkan EAX (Sisa Bagi)
    TampilkanText	hStdOut, msgdiv2, msgd2_len, nBytes
    TampilkanText	hStdOut, strhasil, str_len, nBytes
    jmp END

HASIL:
TampilkanText	hStdOut, msg5, msg5_len, nBytes
TampilkanText	hStdOut, strhasil, str_len, nBytes		; Tampilkan hasil setelah EAX dikonversi ke STRING

END:
TampilkanText	hStdOut, msg6, msg6_len, nBytes

JMP ..start                                             ;Loop ke awal sampai enter ditekan

exit:
push 0
call [ExitProcess]
leave
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
    cmp byte[ebx],0		;; diposisikan pada akhir string strhasil
    je NEXTNULL
    mov byte[ebx],32
    inc ebx
    jmp loop1

NEXTNULL:
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

; CONVERT Numeric (EAX) TO STRING (strhasil) KHUSUS PENGURANGAN NEGATIF
;-------------------------------------------------------------------------------------
Numeric2StrNEG: 

	mov ebx, strhasil	;; hasil konversi disimpan di strhasil  
 
 loop1NEG:
    cmp byte[ebx],0		;; diposisikan pada akhir string strhasil
    je NEXTNULLNEG
    mov byte[ebx],32
    inc ebx
    jmp loop1NEG

NEXTNULLNEG:
	dec ebx

	mov si,10	      		
 loop2NEG:				
	xor edx, edx		;; edx di-nolkan untuk menampung sisa bagi
	div si			;; dilakukan pembagian 10 berulang
	add dl, '0'        	;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl		;; simpan ke strhasil dari belakang ke depan
	dec ebx			;; majukan pointer
	or  eax,eax		;; test apakah yang dibagi sudah nol
	jnz loop2NEG 		;; selesai perulangan jika yang dibagi sdh nol   

    mov byte[ebx],45    ;Tambahkan char '-' Ke depan

ret