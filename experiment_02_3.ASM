 include io.inc
		.model small
		.stack
		.data
	intmsg3First byte 'TCPA Interrupt No.3 start !',13,10,0
	intmsg3Second byte 'TCPA Interrupt No.3 finish !',13,10,0
	intmsg10First byte 'TCPA Interrupt No.10 start !',13,10,0
	intmsg10Second byte 'TCPA Interrupt No.10 finish !',13,10,0
	counter byte 0
		
		.code
;首先对0Bh中断向量进行保护
start:
	mov ax,@data
      mov ds,ax
	mov ax,350Bh
	int 21h
	push es
	push bx
	
;设置新的0Bh中断向量表项
	cli          ;关中断
	push ds
	mov ax,seg new0Bh
	mov ds,ax
	mov dx,offset new0Bh
	mov ax,250Bh
	int 21h
	pop ds
	
;对72h中断向量进行保护
	mov ax,3572h
	int 21h
	push es
	push bx
;设置新的72h中断向量表项
	cli          ;关中断
	push ds
	mov ax,seg new72h
	mov ds,ax
	mov dx,offset new72h
	mov ax,2572h
	int 21h
	pop ds
	
;允许IRQ3中断
	in al,21h   ;读出IMR
	push ax      ;保存原IMR内容
	and al,0f7h  ;允许IRQ3，其他内容不变，即置IRQ3为0
	out 21h,al	 ;设置新IMR内容
;允许IRQ10中断
	in al,0A1h   ;读出IMR
	push ax      ;保存原IMR内容
	and al,0fbh  ;允许IRQ10，其他内容不变，即置IRQ10为0
	out 0A1h,al	 ;设置新IMR内容

	mov counter,0
	sti			 ;开中断
;主程序完成中断服务程序设置，开始处理其他事务
	
start1:
	cmp counter,5
	jb start1
	;
	cli          ;关中断
	pop ax		 ;恢复IMR
	out 21h,al
	pop dx		 ;恢复原中断向量表项
	pop ds
	mov ax,250Bh
	int 21h
	
	pop ax
      out 0A1h,al
      pop dx
      pop ds
      mov ax,2572h
      int 21h
	sti 	
	.exit 0
	
;new3号中断服务程序
new0Bh proc
	   sti		 ;开中断
	   push ax
	   push si
	   push ds
	   mov ax,@data    ;外部随机产生中断，DS也不确定，所以必须设置DS
	   mov ds,ax
	   inc counter	   ;中断次数加1
	   mov si,offset intmsg3First
	   call dpstri
;延时
	   mov ah,86h
	   mov cx,0ffh
	   mov dx,8480h
	   int 15h
	   
;显示中断3第二个字符串
	   mov si,offset intmsg3Second
	   call dpstri
	   mov al,20h      ;发送EOI命令
	   out 20h,al
	   pop ds
	   pop si
	   pop ax
	   iret				;中断返回
new0Bh endp
;new10号中断服务程序
new72h proc
	   sti		 ;开中断
	   push ax
	   push si
	   push ds
	   mov ax,@data    ;外部随机产生中断，DS也不确定，所以必须设置DS
	   mov ds,ax
	   inc counter	   ;中断次数加1;显示中断10第一个字符串
	   mov si,offset intmsg10First
	   call dpstri
	   ;延时
	   mov ah,86h
	   mov cx,0ffh
	   mov dx,8480h
	   int 15h
	   
	   ;显示中断10第二个字符串
	   mov si,offset intmsg10Second
	   call dpstri
	   mov al,20h      ;发送EOI命令
	   out 0a0h,al	   ;写入从片EOI命令
	   out 20h,al	   ;写入主片EOI命令
	   pop ds
	   pop si
	   pop ax
	   iret				;中断返回
new72h endp

dpstri proc				;显示字符串子程序
	   push ax			;入口参数：DS：SI=字符串首址
	   push bx
dsp1:  mov al,[si]
	   cmp al,0
	   jz dps2
	   mov bx,0
	   mov ah,0eh
	   int 10h
	   inc si
	   jmp dsp1
dps2:  pop bx
	   pop ax
	   ret
dpstri endp
	   
		.exit 0
		end start
