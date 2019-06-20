 ;支持子程序库的简化段源程序格式
    include io.inc
	.model small	; 定义程序的存储模式
	.stack	; 定义堆栈段（默认是1KB空间）
	.data	;数据段

	.code	;代码段
start:	
	mov ax,@data
	mov ds,ax
	
	mov al,10h	;00 01 000 1
	mov dx,283h
	out dx,al
	mov al,4
	mov dx,280h
	out dx,al	
	mov bl,al
again:
	call delay
	mov al,00h
	mov dx,283h
	out dx,al
	mov dx,280h
	in al,dx
	call dispuib
	call dispcrlf

	cmp al,bl
	jz again
	mov bl,al
	cmp al,0
	ja again
			
	.exit 0
delay proc
	push cx
	push dx
	mov cx,0fffh
again1:
	mov dx,0ff1h	
again2:
	dec dx
	cmp dx,0
	jnz again2
	loop again1
	pop dx
	pop cx
	ret
delay endp
	end start
