 include io.inc
	.model small
	.stack
	.data
msg	byte 13,10,0
	.code
start:mov dx,283h     ;向8254写控制字
    mov al,36h       ;使0通道为工作方式3
    out dx,al
    mov ax,1000      ;写入循环计数初值1000
    mov dx,280h
    out dx,al        ;先写入低字节
    mov al,ah
    out dx,al        ;后写入高字节
    mov dx,283h
    mov al,76h       ;设8254通道1工作方式2
    out dx,al
    mov ax,1000      ;写入循环计数初值1000
    mov dx,281h
    out dx,al        ;先写低字节
    mov al,ah
    out dx,al        ;后写高字节
    mov ah,4ch       ;程序退出
    int 21h
  code ends
    end start
