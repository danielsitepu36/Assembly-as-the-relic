%include "nagoa.inc"

extern GetModuleHandleA
extern GetCommandLineA
extern ExitProcess
;extern MessageBox
extern MessageBoxA
;extern LoadIcon
extern LoadIconA
;extern LoadCursorA
extern LoadCursorA
extern RegisterClassExA
extern CreateWindowExA
extern ShowWindow
extern GetWindowTextA
extern SetWindowTextA
extern SetFocus
extern UpdateWindow
extern GetMessageA
extern SendMessageA
extern TranslateMessage
extern DispatchMessageA
extern PostQuitMessage
extern DefWindowProcA
extern BeginPaint
extern DrawTextA
extern EndPaint

;; Import the Win32 API functions.
import GetModuleHandleA kernel32.dll
import GetCommandLineA kernel32.dll
import ExitProcess kernel32.dll
;import MessageBox user32.dll
;import LoadIcon user32.dll
import MessageBoxA user32.dll
import LoadIconA user32.dll
;import LoadCursor user32.dll
import LoadCursorA user32.dll
import RegisterClassExA user32.dll
import CreateWindowExA user32.dll
import GetWindowTextA user32.dll
import SetWindowTextA user32.dll
import SetFocus user32.dll
import ShowWindow user32.dll
import UpdateWindow user32.dll
import GetMessageA user32.dll
import SendMessageA user32.dll
import TranslateMessage user32.dll
import DispatchMessageA user32.dll
import PostQuitMessage user32.dll
import DefWindowProcA user32.dll
import BeginPaint user32.dll
import DrawTextA user32.dll
import EndPaint user32.dll

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
