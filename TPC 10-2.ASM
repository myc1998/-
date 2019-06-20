	include io.inc
	.model small
	.stack
	.data
	.code
start:
	mov ax,@data
	mov ds,ax
	mov dx,28bh
	mov al,10001000b;方式0 C端口输入
	
start1:
	mov al,00h;AL=00，再次调用该功能获取扩展ASCII字符代码
	mov dx,298h
	out dx,al

	mov dx,28ah;循环查询是否转换结束
start2:	
	in al,dx;读入状态信息
	test al,80h
	jz start2;没有结束，继续查询

	mov dx,298h
	in al,dx
	call dispuib
	call dispcrlf
	call delay

	mov dl,0ffh;功能：键盘输入功能调用， DL=FF 对应输入功能
	mov ah,06h;直接控制台I/O,若有输入，AL返回输入字符的ASCII字符，否则AL=0
	int 21h
	jz start1
	.exit 0

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