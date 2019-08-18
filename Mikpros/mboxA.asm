%include "console.inc"

judul	db "Helloo", 0 
teks1   db 13,10,13,10," Your Name : ", 0 
pteks1	dd 0 

mbtitle db 'Helloo',0
mbtext	db 'Good Morning '


text2   db ' -- God Bless You !!!',0
ptext2  dd $-text2

buff	resb 16
buff_len	dd 16

section .bss 	; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1


segment .code use32
..start:	

 initconsole judul, hStdOut, hStdIn				; CREATE CONSOLE
 display_text teks1, pteks1, nBytes, hStdOut	; DISPLAY TEXT MESSAGE

 call read_text									; READ TEXT FROM KEYBOARD

 call mbox

 push dword 0
 call [ExitProcess]
 leave
ret

segment .data use32

mbox:
 mov esi, buff		; mbtext + buff + text2 (menyambung 3 string)
 add esi, [iBytes]
 sub esi,2

 mov dl,' '
 mov [esi], dl
 inc esi
 mov ecx, [ptext2]
 mov ebx, text2
 cpt:
	mov dl, byte [ebx]
	mov [esi], dl
	inc esi
	inc ebx
 loop cpt
 
 push dword 30h			; tombol Button
 push dword mbtitle		; judul windows
 push dword mbtext  		; Pesan yg ditampilkan, diakhiri 0 (null)
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
 