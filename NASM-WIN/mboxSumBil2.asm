%INCLUDE "console1.inc"

;DEKLARASI VARIABEL
;------------------------------------------------------------------------------------------------
section .data 		

judul			db "Menjumlahkan Sederetan Bilangan", 0 
teks1           db 13,10,13,10,"Tuliskan Bilangan2 diakhiri dengan 0  : ", 13,10,0 
pteks1			dd 0 
teks2           db 13,10,13,10,"Hasil penjumlahan : ", 0 
pteks2			dd 0 
teks3			db 13,10,13,10,"Lagi ? (y/t) : ",0 
pteks3	        dd 0 


buff			resb 255
buff_len		dd 255

bil				resd 1 
bilx2			resd 1

strhasil		db '           ',0
str_len			db 12

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1

; MULAI PROGRAM
;--------------------------------------------------------------------------------------------------
section .text use32 
..start: 
initconsole judul, hStdOut, hStdIn

ULANGI:
    mov [bilx2], dword  0
	tampilkan_teks teks1, pteks1, nBytes, hStdOut

	bacalagi:
		call BacaStr
		call Str2Bil
		mov eax, [bil]
		cmp eax,0
		je result
		add [bilx2], eax
		jmp bacalagi
	
	result:
	call Bil2Str
		
	xor eax,eax
	call ShowResult
	
	cmp eax, 4  ; Tombol Retry ditekan
	je ULANGI

quitconsole
;=================================================================================================
; MENGKONVERSI STRING(buff) KE NUMERIK  (bil) 
;-------------------------------------------------------------------------------------
Str2Bil:
        xor eax,eax				;set hasil = 0
        mov esi, 10				;pengali 10
        mov ebx, buff
		mov ecx, [iBytes]
		sub ecx, 2
		xor edx,edx
    Loopbil:
        mul esi 				;hasil sebelumnya * 10
        mov dl, byte [ebx]
        sub dl,30h 				;ubah ke 0-9
        add eax,edx 			;tambahkan dg digit terakhir 
        inc ebx
        loop Loopbil
    
	mov [bil], eax
ret
;-------------------------------------------------------------------------------------
; MENGKONVERSI NUMERIK (bil) KE STRING (strhasil) 
;-------------------------------------------------------------------------------------
Bil2Str:
	mov ebx, strhasil			;; hasil konversi disimpan di strhasil
 loop1:
    mov byte[ebx],' '
	inc ebx						;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0				;; diposisikan pada akhir string strhasil 
	jne loop1
	dec ebx    

	mov eax, [bilx2]			;; bilx2 berisi bilangan yg akan dikonversi
	mov esi,10
 loop2:
	xor edx, edx				;; edx di-nolkan untuk menampung sisa bagi
	div esi						;; dilakukan pembagian 10 berulang
	add dl, '0'        			;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl				;; simpan ke strhasil dari belakang ke depan
	dec ebx						;; majukan pointer
	or  eax,eax					;; test apakah yang dibagi sudah nol
	jnz loop2 					;; selesai perulangan jika yang dibagi sdh nol
ret
;--------------------------------------------------------------------------------------
BacaStr:
							;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 				;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 			;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 			;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------
TampilkanStrhasil:
push dword 0 				;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes			;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [str_len] 		;; parameter ke 3 panjang string
push dword strhasil			;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

ShowResult:
 push dword 5			; tombol OK
 push dword teks2		; judul windows
 push dword strhasil    ; Pesan yg ditampilkan, diakhiri dengan 0 (null)
 push dword 0			; owner windows dari msgbox, atau NULL (tdk punya owner)
 call [MessageBoxA]
ret
;--------------------------------------------------------------------------------------------------
