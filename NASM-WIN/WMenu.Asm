%include "nagoa.inc"

%macro importx 2
		import %1 %2
		extern %1
%endmacro


;; Import the Win32 API functions.
importx GetModuleHandleA, kernel32.dll
importx GetCommandLineA, kernel32.dll
importx ExitProcess, kernel32.dll
importx MessageBoxA, user32.dll
importx LoadIconA, user32.dll
importx LoadCursorA, user32.dll
importx RegisterClassExA, user32.dll
importx CreateWindowExA, user32.dll
importx GetWindowTextA, user32.dll
importx SetWindowTextA, user32.dll
importx SetFocus, user32.dll
importx ShowWindow, user32.dll
importx UpdateWindow, user32.dll
importx GetMessageA, user32.dll
importx SendMessageA, user32.dll
importx TranslateMessage, user32.dll
importx DispatchMessageA, user32.dll
importx PostQuitMessage, user32.dll
importx DefWindowProcA, user32.dll
importx BeginPaint, user32.dll
importx DrawTextA, user32.dll
importx EndPaint, user32.dll

%define call call_

%imacro call_ 1-*  
%assign i	%0
	%if %0 > 1
		%rep %0 - 1
			%rotate -1  
			%assign i	i-1		                               
			%rotate -1
			%ifidni %1,"ADDR_"
			%rotate 1
			lea	eax,	[%1]
			push	eax
			%rotate -1
			%assign i	i-1
			%else		
			%rotate 1
			STDPUSH {%1}     
			%endif
			%if i <=1
			%exitrep
			%endif
		%endrep		
		%rotate -1
	%endif
	%ifndef %1_definida
                ; é uma funçao externa ?   ( hgb )
                extern %1     ; declare API function as external
                CALL [%1]          ; call API function via IAT
        %else
                ;é uma  funçao local
                CALL %1
        %endif
%endmacro


def WinMain
def WinProc

[segment .data USE32]
Instance        dd 0
CmdLine         dd 0
hwndButton      dd 0
hwndEdit        dd 0

ClassName       db "MenuClass",0
MenuName        db "FirstMenu",0
AppName         db "MessageBox",0
ButtonClassName db "button",0
ButtonText      db "Tampilkan Isiya",0
EditClassName   db "edit",0
Test_string     db "Ini isinya EditBox",0

ButtonID        equ 1111
EditID          equ 2222
IDM_HELLO       equ 1
IDM_CLEAR       equ 2
IDM_GETTEXT     equ 3
IDM_EXIT        equ 4

buffer          resb 512
   
[segment .code USE32]
..start:
    call GetModuleHandleA, NULL
	mov dword[Instance], eax
	
	call GetCommandLineA, NULL
	mov dword[CmdLine], eax
	call WinMain, [Instance], NULL, eax, SW_SHOWDEFAULT
	call ExitProcess, NULL


proc WinMain, hInstance, hPrevInstance, lpCmdLine, nCmdShow

    stack wc,WNDCLASSEX_size
    stack msg, MSG_size
    stack hwnd, 4

	mov dword[wc+WNDCLASSEX.cbSize], WNDCLASSEX_size
	mov dword[wc+WNDCLASSEX.style], CS_VREDRAW | CS_HREDRAW
	mov dword[wc+WNDCLASSEX.lpfnWndProc], WinProc
	mov dword[wc+WNDCLASSEX.cbClsExtra], NULL
	mov dword[wc+WNDCLASSEX.cbWndExtra], NULL
	m2m dword[wc+WNDCLASSEX.hInstance], [Instance]
	mov dword[wc+WNDCLASSEX.hbrBackground],COLOR_BTNFACE+1
	mov dword[wc+WNDCLASSEX.lpszMenuName], MenuName
	mov dword[wc+WNDCLASSEX.lpszClassName], ClassName
	call LoadIconA, NULL, IDI_APPLICATION
	mov dword[wc+WNDCLASSEX.hIcon], eax
	mov dword[wc+WNDCLASSEX.hIconSm], eax
	call LoadCursorA, NULL, IDC_ARROW
	mov dword[wc+WNDCLASSEX.hCursor], eax
	lea eax,[wc]
    call RegisterClassExA, eax
	call CreateWindowExA, WS_EX_CLIENTEDGE, ClassName, "Contoh MENU", WS_OVERLAPPEDWINDOW, 364, 128, 300, 250, NULL, NULL, [hInstance], NULL
	mov dword[hwnd], eax
	call ShowWindow, [hwnd], [nCmdShow]
	call UpdateWindow, [hwnd]
.loop:
	lea eax,[msg]
    call GetMessageA, eax, NULL, 0, 0
	cmp eax, 0
	jb .erro
	je .fin
	lea eax, [msg]
	call TranslateMessage, eax
	lea eax, [msg]
	call DispatchMessageA, eax
	jmp .loop
	.erro:
	call MessageBoxA, 0, "An unexpected error has occurred.", "Report", MB_OK
	.fin:
	mov eax, dword[msg+MSG.wParam]
endproc

proc WinProc, hWnd, uMsg, wParam, lParam
	mov eax, dword[uMsg]
	cmp eax, WM_DESTROY
	je near .DESTROY
    cmp eax,WM_CREATE
    je near .CREATE
    cmp eax,WM_COMMAND
    je near .COMMAND
	;-------
    call DefWindowProcA, [hWnd], [uMsg], [wParam],[lParam]
	return

    ;------
    .CREATE:
	call CreateWindowExA, WS_EX_CLIENTEDGE, EditClassName, NULL, WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT | ES_AUTOHSCROLL, 50,35,200,25,[hWnd],EditID,[Instance],NULL
	mov [hwndEdit],eax
	call SetFocus, [hwndEdit]
	call CreateWindowExA, NULL, ButtonClassName, ButtonText, WS_CHILD | WS_VISIBLE | BS_DEFPUSHBUTTON, 75,70,140,25,[hWnd],ButtonID,[Instance],NULL
	mov  [hwndButton],eax
    return FALSE

    .COMMAND:
    mov eax,[wParam]
    
    cmp ax, IDM_HELLO
    jne .L001
	call SetWindowTextA,[hwndEdit],Test_string
	call SendMessageA,[hwndEdit],WM_KEYDOWN,VK_END,NULL
    .L001:
    
    cmp ax, IDM_CLEAR
    jne .L002
    call SetWindowTextA,[hwndEdit],NULL
    .L002:
    
    cmp ax, IDM_GETTEXT
    jne .L003
	call GetWindowTextA,[hwndEdit],buffer,512
	call MessageBoxA,NULL, buffer, AppName,MB_OK
    .L003:
    
    cmp ax, IDM_EXIT
    jne .L004
    call PostQuitMessage, 0
    .L004:
    
    cmp ax, ButtonID
    jne .L005
    shr eax, 16
    cmp ax, BN_CLICKED
    jne .L0051
       call SendMessageA,[hWnd],WM_COMMAND, IDM_GETTEXT, 0	
    .L0051:
    .L005: 
    return FALSE

    .DESTROY:
	call PostQuitMessage, 0
endproc

; -- end of file
