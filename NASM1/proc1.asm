SEGMENT .DATA 
data1 dw 0005
data2 dw 0015
hasil dw 0

SEGMENT .CODE 
..start:
	MOV AX, [data1]
	MOV BX, [data2]

	CALL [tambahkan]

        MOV [hasil], AX
	
	
RET

tambahkan:

	ADD AX, BX
        RET