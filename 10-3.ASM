	include io.inc
	.model small
	.stack
	.data
intoff word ?
intseg word ?
adtemp byte 0
	.code
start:
	mov ax,@data
	mov ds,ax
	
	mov ax,350bh;获取系统的原0BH中断向量表项
	int 21h
	mov intoff,bx;保存偏移地址
	mov intseg,es;保存段基地址
	
	push ds
	mov dx,offset new0bh ;
	mov ax,seg new0bh
	mov ds,ax
	mov ax,250bh;设置本程序的80H中断向量表项
	int 21h
	pop ds
	
	in al,21h;读IMR
	and al,0f7h;允许IRQ3
	out 21h,al;设置新IMR内容

again:
	mov al,00h;AL=00，再次调用该功能获取扩展ASCII字符代码
	mov dx,298h
	out dx,al
		
	mov al,adtemp
	call dispuib
	call dispcrlf

	mov dl,0ffh;功能：直接控制台I/O， DL=FF 输入
	mov ah,06h;直接控制台I/O,若有输入，AL=输入字符，否则AL=0
	int 21h
	jz again
	.exit 0

new0bh proc  ;中断
	sti
	  
	push ax
	push dx
	push ds

	mov ax,@data
	mov ds,ax
	mov dx,298h
	in al,dx;读取A/D转换后的数字量
	mov adtemp,al;送入缓冲区
	call delay
	mov al,20h;发送EIO命令
	out 20h,al
	pop ds;恢复寄存器
	pop dx
	pop ax
	iret;中断返回
new0bh endp

;延时子程序	
delay proc 
	push bx
	push cx
	mov bx,100
delay1: xor cx,cx
delay2:
	loop delay2
	dec bx
	jnz delay1
	pop cx
	pop bx
	ret
delay endp


end start 