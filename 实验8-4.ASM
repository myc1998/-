	include io.inc
	.model small
	.stack
	.data
mod 	byte 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,6fh
qian 	byte 0
bai 	byte 0
shi 	byte 0
ge 	byte 0
	.code
start:
	mov ax,@data
	mov ds,ax
	mov al,10000000b
	mov dx,28bh
	out dx,al
again:
	mov dx,289h
	mov al,0001b
	out dx,al
	mov bx,0
	mov bl,ge
	mov al,mod[bx]
	mov dx,288h
	out dx,al
	call delay

	mov dx,289h
	mov al,0010b
	out dx,al
	mov bx,0
	mov bl,shi
	mov al,mod[bx]
	mov dx,288h
	out dx,al
	call delay


	mov dx,289h
	mov al,0100b
	out dx,al
	mov bx,0
	mov bl,bai
	mov al,mod[bx]
	mov dx,288h
	out dx,al
	call delay


	mov dx,289h
	mov al,1000b
	out dx,al
	mov bx,0
	mov bl,qian
	mov al,mod[bx]
	mov dx,288h
	out dx,al
	call delay
	
	
	cmp ge,9
	jz ge10
	jnz ge1
ge10:
	mov ge,0
	inc shi
	jmp shitest
ge1:
	inc ge

shitest:
	cmp shi,10
	jnz baitest
	mov shi,0
	inc bai

baitest:
	cmp bai,10
	jnz qiantest
	mov bai,0
	inc qian
qiantest:
	cmp qian,10
	jz quit
	jmp again
quit:
	.exit 0


timer	=5
delay	proc
	push bx
	push cx
	mov bx,timer
delay1:
	xor cx,cx
delay2:
	loop delay2
	dec bx
	jnz delay1
	pop cx
	pop bx
	ret
delay endp



end start 