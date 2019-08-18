GORC /r %1.rc

NASM -fobj %1.asm -l%1.lst

ALINK -oPE %1.obj %1.res