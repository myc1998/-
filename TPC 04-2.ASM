  include io.inc
	.model small
	.stack
	.data
intmsg byte 'TPCA Interrupt No.10!',0dh,0ah,0
counter byte 0
	.code
start:
	mov ax,@data
	mov ds,ax

	mov ax,3572h
	int 21h
	push es
 	push bx
	cli
	push ds
	mov ax,seg new72h
	mov ds,ax
	mov dx,offset new72h
	mov ax,2572h
	int 21h
	pop ds
	in al,0a1h
	push ax
	and al,0fbh
	out 0a1h,al
	mov counter,0
	sti

start1:
	cmp counter,5
	jb start1
  	.exit 0
	cli
	pop ax
	out 21h,al
	pop dx
	pop ds
	mov ax,2572h
	int 21h
	sti

new72h proc
	 sti
	 push ax
	 push si
	 push ds
	 mov ax,@data
	 mov ds,ax
	 inc counter
	 mov si,offset intmsg
	 call dpstri
	 mov al,20h
	 out 0a0h,al
	 out 20h,al
	 pop ds
	 pop si
	 pop ax
	 iret
new72h endp

dpstri proc
	 push ax
	 push bx
dps1:
	 mov al,[si]
	 cmp al,0
	 jz dps2
	 mov bx,0
	 mov ah,0eh
	 int 10h
	 inc si
	 jmp dps1
dps2:
	 pop bx
	 pop ax
	 ret
dpstri endp




 
	end start
