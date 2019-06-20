  	include io.inc
	.model small
	.stack
	.data
msg	byte 'Press any key to exit.',13,10,0
	.code

start:
	mov ax,@data
	mov ds,ax
	mov ax, offset msg
	call dispmsg	

again:	
	mov dx,298h	
	mov al,0ffh
	out dx,al

	call delay	      
	in al,dx	      
	call disphb	      
      call dispcrlf   
	call readkey      
	je again	      
	.exit 0	

;ÑÓÊ±×Ó³ÌÐò
delay proc
	push bx
	push cx
	mov bx, 100

delay1: 
	xor cx, cx
delay2:
	loop delay2
	dec bx
	jnz delay1
	pop cx
	pop bx
	ret	
delay endp

	end start 