 include io.inc
.model small

.stack
.data
ledtb byte 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,6fh
.code
start:  mov ax,@data
        mov ds,ax

        mov dx,28bh
        mov al,80h          ;(10000000b)
        out dx,al          ;写入方式控制字
        call readuib       ;输入数据
        mov bl,al
	  mov bh,0
        mov al,ledtb[bx]
        mov dx,288h     ;送端口地址
        out dx,al
        .exit 0
        end start 