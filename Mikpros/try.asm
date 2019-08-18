%include "console.inc"

Title   	db "MIKROPROSESOR DANIEL - 18290",0 

msg0 		db 13,10,"---Daniel Suranta S / 18-424185-PA-18290---",0
msg0_len 	dd $-msg0
deco		db 13,10,"===========================================",0
deco_len	dd $-deco
msgout 		db 13,10,"Masukkan '0' untuk selesai !",0
msgo_len 	dd $-msgout
msg1 		db 13,10,"Masukkan angka     =>",0
msg1_len 	dd $-msg1
msgbox 		db 13,10,"Do you want to retry ? ",0
box_len 	dd $-msgbox

mbtitle db 'HASIL PENJUMLAHAN',0
mbtext	    db 'Hasil = '
strhasil	db '               ',0
str_len		db 15  

buff		resb 255
buff_len	dd 255



section .bss 	; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1


segment .code use32
..start:	

initconsole     Title, hStdOut, hStdIn				; CREATE CONSOLE
display_text	deco, deco_len, nBytes, hStdOut
display_text	msg0, msg0_len, nBytes, hStdOut
display_text	deco, deco_len, nBytes, hStdOut

display_text	msgout, msgo_len, nBytes, hStdOut

xor edi,edi

input:
display_text	msg1, msg1_len, nBytes, hStdOut 
call read_text									; READ TEXT FROM KEYBOARD
    call Str2Bil
    cmp eax,0
    je END
    add edi, eax
    jmp input

END:
mov eax,edi
call Numeric2Str
xor eax,eax
call mbox
call exitbox
cmp eax, 7
je EXIT

jmp ..start

EXIT:

push dword 0
call [ExitProcess]
leave
ret

SEGMENT .DATA use32

mbox:

 push dword 0h			; tombol Button
 push dword mbtitle		; judul windows
 push dword mbtext    ; Pesan yg ditampilkan, diakhiri 0 (null)
 push dword 0			; owner windows dari msgbox, atau NULL (tdk punya owner)

 call [MessageBoxA]
ret

exitbox:
 
 push dword 4h			; tombol Button
 push dword mbtitle		; judul windows
 push dword msgbox    ; Pesan yg ditampilkan, diakhiri 0 (null)
 push dword 0			; owner windows dari msgbox, atau NULL (tdk punya owner)

 call [MessageBoxA]
ret

read_text:
							;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 				;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 			;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 			;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			
ret

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