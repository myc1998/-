 ;支持子程序库的简化段源程序格式
    include io.inc
	.model small	; 定义程序的存储模式
	.stack	; 定义堆栈段（默认是1KB空间）
	.data	;数据段

	.code	;代码段
start:	
	mov ax,@data
	mov ds,ax
	
	mov al,10h	;00 11 000 1 控制字
	mov dx,283h  ;写8254控制端口
	out dx,al
	mov ax,3
	mov dx,280h   ;0号计数器
	out dx,al	
       mov ah,al
       out dx,al
again:
	call delay
	mov al,00h
	mov dx,283h
	out dx,al
	mov dx,280h
	in al,dx
	call dispuib
	cmp al,0
   	jnz again
			
	.exit 0
delay proc
        push cx
        push dx
        mov ah,86h
	mov cx,0ffh
        mov dx,8480h
        int 15h
        pop cx
        pop dx 
delay endp
end start
