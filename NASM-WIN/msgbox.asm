IMPORT MessageBoxA user32.dll
IMPORT ExitProcess kernel32.dll
EXTERN MessageBoxA	
EXTERN ExitProcess	

segment .code use32
..start:	

 push dword 1		; tombol OK
 push dword title1	; judul windows
 push dword string1     ; Pesan yg ditampilkan, diakhiri dengan 0 (null)
 push dword 0		; Owner atau 0
 call [MessageBoxA]

 push dword 0
 call [ExitProcess]
 leave
ret

segment .data use32
string1: db 'Menampilkan Text dalam KotakPesan',13,10,
         db 'Menggunakan WindowsAPI [MessageBoxA]',13,10,
	 db 'Dengan pilihan tombol 0 [OK]',13,10,
	 db 'pilihan lainnya: 1 [OK/CANCEL]',13,10,
	 db '	2 [ABORT/RETRY/CANCEL]',13,10,
	 db '	3 [YES/NO/CANCEL]',13,10,
	 db '	4 [YES/NO]',13,10,
	 db '	5 [RETRY/CANCEL]',0

title1:  db 'Contoh Program Assembly',0
 