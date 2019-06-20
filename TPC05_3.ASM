   ;支持子程序库的简化段源程序格式
    include io.inc
	.model small	; 定义程序的存储模式
	.stack	; 定义堆栈段（默认是1KB空间）
	.data	;数据段
intmsg byte 'TPCA Interrupt No.3!',0dh,0ah,0
counter byte 0
	.code	;代码段
start:	
	mov ax,@data
	mov ds,ax
	
	mov al,00110110B
	mov dx,283h
	out dx,al	
	mov ax,1000
	mov dx,280h
	out dx,al
	mov al,ah
	out dx,al

	mov al,01110110B
	mov dx,283h
	out dx,al
	mov ax,1000
	mov dx,281h
	out dx,al
	mov al,ah
	out dx,al
	
	mov ax,350Bh
	int 21h
	push es
	push bx
	cli
	push ds
	mov ax,seg new0Bh
	mov ds,ax
	mov dx,offset new0Bh
	mov ax,250Bh
	int 21h
	pop ds
	in al,21h
	push ax
	and al,0f7h
	out 21h,al
	mov counter,0
	sti
start1:cmp counter,5
	jb start1
	cli
	pop ax
	out 21h,al
	pop dx
	pop ds
	mov ax,250Bh
	int 21h
	sti
	.exit 0
new0Bh proc
	push ax
	push si
	push ds
	mov ax,@data
	mov ds,ax
	inc counter
	mov si,offset intmsg
	call dpstri
	mov al,20h
	out 20h,al
	pop ds
	pop si
	pop ax
	iret
new0Bh endp
	
dpstri proc
	push ax
	push bx
dps1: mov al,[si]
      cmp al,0
	jz dps2
	mov bx,0
	mov ah,0eh
	int 10h
	inc si
	jmp dps1
dps2: pop bx
	pop ax
	ret
dpstri endp
	end start
