include io.inc
	.model small
	.stack
	.data
leddt byte 3,4,5,6
;ledtb byte 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c1h,86h,8eh
ledtb byte 3fh,06h,05bh,04fh,66h,6dh,7dh,07h,7fh,6fh
	.code
start:
	  mov ax,@data
        mov ds,ax 
again:  
	  mov dx,28bh
        mov al,80h
        out dx,al
        mov si,offset leddt
        call displed
        jmp again
        .exit 0

displed proc
	push ax
	push bx
	push dx
	xor bx,bx
	mov ah,01h;指向最左边的数码管
led1: mov bl,[si];取出要显示的数字
	inc si	;
	mov al,ledtb[bx];得到显示代码：AL->LEDTB[BX]
	mov dx,288h;segport为段控制端口
	out dx,al;送出段码
	mov al,ah;取出位显示代码
	mov dx,289h;位控制端口
	out dx,al;送出位码
	call delay;实现数码管延时显示
      rol ah,1
	cmp ah,10h;是否指向最右边数码管
	jnz led1;没有，显示下一个数字
	pop dx
	pop bx
	pop ax
	ret
displed endp
;延时子程序
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
 