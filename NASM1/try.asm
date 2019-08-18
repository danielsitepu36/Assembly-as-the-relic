%INCLUDE "winAPI.inc" ;;Declare external procedure {winapi} in file winAPI.inc

SEGMENT .DATA use32
Title   	    db "MIKROPROSESOR DANIEL - 18290",0 

msg0 			db 13,10,"---Daniel Suranta S / 18-424185-PA-18290---",0
msg0_len 		dd $-msg0

msg1 			db 13,10,"TULIS TEXT (Selesai? Enter)   : ",0
msg1_len 	    dd $-msg1

msg2 			db 13,10,"UBAH KE HURUF BESAR           : ",0
msg2_len 	    dd $-msg2 

msg3 			db 13,10,"DIBALIK MENJADI               : ",0
msg3_len 	    dd $-msg3

msg4 			db 13,10,"JUMLAH CHARACTER (TANPA SPASI): ",0
msg4_len 	    dd $-msg4

msg5 			db 13,10,13,10,"JUMLAH KATA                   : ",0
msg5_len 	    dd $-msg5

msg6 			db 13,10,13,10,"TERIMA KASIH",13,10,0
msg6_len 	    dd $-msg6

deco			db 13,10,"===========================================",0
deco_len		dd $-deco

buff		resb 255
buff_len	dd 255

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
push dword [deco_len] 	;; parameter ke 3 panjang string
push dword deco		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg0_len] 	;; parameter ke 3 panjang string
push dword msg0			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [deco_len] 	;; parameter ke 3 panjang string
push dword deco		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 

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

cmp dword [iBytes],2    ;; Jika hanya ditekan Enter (2 char) maka Exit
je EXIT	

mov ECX, [iBytes]		;; iBytes menyimpan panjang string yang dituliskan, termasuk Enter (2 bytes: 13,10)
sub ECX, 2

mov EBX, dword buff
sub EDX, EDX			;;untuk menyimpan jumlah spasi/kata/cluster
sub EDI, EDI			;;untuk menyimpan jumlah char

;; Convert to Uppercase
TOUPPER:
	 cmp byte [EBX], 97					;;cek jika dibawah 97 tidak di UPPERCASE
	 jl NOTWORD
	 cmp byte [EBX], 122				;;cek jika diatas 122 tidak di UPPERCASE
	 jg NOTWORD
	 sub byte [EBX],32					;;Jika benar huruf kecil, UPPERCASE
	 NOTWORD:
	 	cmp byte [EBX], 32				;;cek spasi
	 	jne NOTSPACE
	 		inc EBX						;;cek Data[i+1] untuk menghitung cluster
			cmp byte[EBX],32			;;apabila Data[i+1]=spasi, belum dihitung cluster
			je SPACEAGAIN
			inc EDX						;;tambah jumlah cluster jika spasi sudah habis
			SPACEAGAIN:
				dec EBX
				jmp SPACE
	 	NOTSPACE:
     		inc EDI						;;increment jumlah char
			 	SPACE:
     			inc EBX						;;increment data (i++)
     LOOP TOUPPER

add EBX,2
mov byte [EBX], 0


call countWordNChar		;; Fungsi menghitung jumlah char dan kata & convert to string


;; Print uppercase
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
;; Print uppercase

;; REVERSE
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg3_len] 	;; parameter ke 3 panjang string
push dword msg3			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 


call REVERSE			;; Call Reverse Function to reverse buff


;; Print reversed
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 	;; parameter ke 3 panjang string
push dword buff			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 	

;; Print jumlah karakter & kata
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg4_len] 	;; parameter ke 3 panjang string
push dword msg4			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [char_len] 	;; parameter ke 3 panjang string
push dword char			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg5_len] 	;; parameter ke 3 panjang string
push dword msg5			;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 	      

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [words_len] 	;; parameter ke 3 panjang string
push dword words		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile]

push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [msg6_len] 	;; parameter ke 3 panjang string
push dword msg6 		;; parameter ke 2 string yang akan ditampilkan
push dword [hStdOut] 	;; parameter ke 1 handle stdout
call [WriteFile] 	      

call CLEAR				;; memanggil fungsi clear untuk membersihkan string char dan words

jmp ..start				;; Looping untuk string baru

EXIT: 
push 0
call [ExitProcess]
leave
RET


; KUMPULAN FUNGSI
;-------------------------------------------------------------------------------------
;;FUNGSI MENGHITUNG WORD & CHAR, CONVERT TO STRING
countWordNChar:
	;; Count chars
	mov ESI, EDX
	add ESI, 1
	mov EAX, EDI
	mov EDI, dword char

	;; Convert sum of character to string
	mov EBX, 10
	sub EDX, EDX
	characterTOSTRING:
		div EBX
		add EDX, 48
		mov dword [EDI], EDX
		sub EDX, EDX
		inc EDI
		cmp EAX, 0
		je NEXT1
		jmp characterTOSTRING

	;; Count words
	NEXT1:
	mov EAX, ESI
	mov ESI, dword words
	sub EDX, EDX
	mov EBX, 10

	;; Convert sum of word to string
	wordTOSTRING:
		cmp EAX, 0
		je NEXT2
		div EBX
		add EDX, 48
		mov dword [ESI], EDX
		sub EDX, EDX
		inc ESI
		jmp wordTOSTRING

	;; Reverse string char
	NEXT2:
	mov ECX, 10
	mov EAX, dword char
	mov ESI, EAX
	add EAX, ECX
	mov EDI, EAX
	dec EDI
	shr ECX, 1
	jz NEXT3
	reverseTotalChar:
		mov AL, byte [ESI]
		mov BL, byte [EDI]
		mov byte [ESI], BL 
		mov byte [EDI], AL
		inc ESI
		dec EDI
		dec ECX
		jnz reverseTotalChar

	;; Reverse string words
	NEXT3:
	mov ECX, 10
	mov EAX, dword words
	mov ESI, EAX
	add EAX, ECX
	mov EDI, EAX
	dec EDI
	shr ECX, 1
	jz STOP
	reverseTotalWords:
		mov AL, byte [ESI]
		mov BL, byte [EDI]
		mov byte [ESI], BL 
		mov byte [EDI], AL
		inc ESI
		dec EDI
		dec ECX
		jnz reverseTotalWords

	;; Count word and character end
STOP:
RET

;; FUNGSI REVERSE
REVERSE:
	mov ECX, [iBytes]
	sub ECX, 2
	mov EAX, dword buff
	mov ESI, EAX
	add EAX, ECX
	mov EDI, EAX
	dec EDI
	shr ECX, 1
	jz REVERSED
	rev:
		mov AL, byte [ESI]
		mov BL, byte [EDI]
		mov byte [ESI], BL 
		mov byte [EDI], AL
		inc ESI
		dec EDI
		dec ECX
		jnz rev
REVERSED:
RET

;;FUNGSI CLEAR
CLEAR:
	;;Clear char & words untuk loop selanjutnya
	sub EDX, EDX
	mov EDI, dword char
	mov ESI, dword words
	add EDX, 10
	CLR:
		mov byte[EDI],0
		mov byte[ESI],0
		inc EDI
		inc ESI
		dec EDX
		cmp EDX,0
		jnz CLR
RET