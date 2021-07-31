EXTRN out_bin: near
EXTRN uns_dec_fig: word
EXTRN uns_bin: byte
PUBLIC zero_bin
CodeS	SEGMENT	WORD PUBLIC 'CODE'
	ASSUME CS:CodeS
small_sub proc near
		mov cx, 0
		mov cl, al
		mov uns_dec_fig, cx
		add uns_bin[bx], ah
		mov cx, 2
		dec	bx
		jmp convertation_bin
small_sub endp
zero_bin proc near
	mov bx, 2
	mov cx, 16
	zeroing_bin:
		mov uns_bin[bx], '0'
		inc bx
		loop zeroing_bin
	ret
zero_bin endp
big_sub proc near
		mov uns_dec_fig, ax
		add uns_bin[bx], dl
		dec	bx
		jmp convertation_bin
big_sub endp
convertation_bin proc near
		mov si, 2
		mov dx, 0
		mov ax, 0
		mov ax, uns_dec_fig
		cmp ax, 0
		je out_bin
		div	cx
		mov si, dx
		cmp si, 2
		je	small_sub
		cmp si, 2
		jne	big_sub
		ret
convertation_bin endp
convert_bin proc near
	mov ax, 0
	mov bx, 17
	mov cx, 2
	call convertation_bin
	mov ah, 9
	mov dx, OFFSET uns_bin
	int 21h
	ret
convert_bin endp
	
CodeS ENDS
END