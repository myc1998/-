  ;支持子程序库的简化段源程序格式
    include io.inc
	.model small	; 定义程序的存储模式
	.stack	; 定义堆栈段（默认是1KB空间）
	.data	;数据段

	.code	;代码段
start:	
	mov ax,@data
	mov ds,ax
	
	mov al,00110110B
	mov dx,283h
	out dx,al	
	mov ax,1000
	mov dx,280h
	out dx,al
	mov al,ah
	out dx,al

	mov al,01110110B
	mov dx,283h
	out dx,al
	mov ax,1000
	mov dx,281h
	out dx,al
	mov al,ah
	out dx,al

	.exit 0

	end start
