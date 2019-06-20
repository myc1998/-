 include io.inc
	.model small
	.stack
	.data
msg	byte 'TPCA InternetNo.3!',0dh,0ah,0
counter byte 0
	.code
start:
	mov ax,@data
	mov ds,ax
	
	mov ax,350bh  ;获取原中断向量表
	int 21h
	push es	;保存原中断向量表项
	push bx
	cli		;关中断
	push ds
	mov ax,seg new0bh
	mov ds,ax
	mov dx,offset new0bh
	mov ax, 250bh
	int 21h       ;设置新中断
	pop ds
	in al,21h    ;读出imr
	push ax		;保持原IMR内容
	and al,0f7h	;允许irq3，其他不变
	out 21h,al			;设置新的imr内容
	mov counter,0		;设置中断初始次数
	sti         ;开中断

start1:
	cmp counter,5
	jb start1
      .exit 0 
	
	cli
	pop   ax   ;恢复imr
	out 21h,al
	pop dx
	pop ds
	mov ax,250bh
	int 21h
	sti
;中断服务程序
new0bh  proc
	sti
	push ax	;保护寄存器
	push si
	push ds
	mov ax,@data	;外部随机产生中断，ds也不确定，所以必须设置ds
	mov ds,ax
	inc counter
	mov si,offset msg
	call   dpstri
	mov al,20h		
	out 20h,al			;普通中断结束EOI方式
	pop ds
	pop si
	pop ax
	iret			;中断返回
new0bh endp 

dpstri proc			;显示字符处子程序
	 push ax
	 push bx
dps1:					;字符显示程序
	 mov al,[si]
	 cmp al,0
	 jz dps2
	 mov bx,0
	 mov ah,0eh
	 int 10h
	 inc si
	 jmp dps1
dps2:					;恢复寄存器
	 pop bx
	 pop ax
	 ret
dpstri endp


	end start








