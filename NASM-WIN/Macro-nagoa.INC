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

%macro stack 1-*
%ifctx rotin
%assign somasizelocal 0
%assign %%pare_Argts ((%0) / 2)
%rep %%pare_Argts
%assign somasizelocal somasizelocal+%2
;======
defenir_os_arg_locais %2,%1  ; chamar defenir local arg
;======
%assign n_arg_l n_arg_l+1  ; INCREMENTAR PARA O PROXIMO LOCAL !
%assign c_local_  n_arg_l
%rotate 2
%endrep
sub esp,somasizelocal
%endif
%endmacro

%macro m2m 2
push dword %2
pop dword %1
%endmacro

%macro M2M 2
push dword %2
pop dword %1
%endmacro
