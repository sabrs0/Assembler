EXTRN out_hex: near
EXTRN uns_dec_fig: word
EXTRN s_hex: byte
EXTRN sign: byte
EXTRN s_dec: word
CodeS	SEGMENT	WORD PUBLIC 'CODE'
	ASSUME CS:CodeS
make_usual_get proc near
	mov ax, uns_dec_fig
	mov s_dec, ax
	jmp convert_dec_to_hex
make_usual_get endp
zero_hex proc near
	mov bx, 0
	mov cx, 4
	zeroing_hex:
		mov s_hex[bx], '0'
		inc bx
		loop zeroing_hex
	ret
zero_hex endp
compare_vals proc near
	call zero_hex
	cmp uns_dec_fig, 32767
	ja	inverse_bin
	;cmp uns_dec_fig, 32767
	jmp	make_usual_get
compare_vals endp
inverse_bin proc near
	mov sign, '-'
	mov ax, uns_dec_fig
	;not ax
	;inc ax
	
	mov s_dec, ax
	jmp convert_dec_to_hex
inverse_bin endp
invert_symb_small proc near
	add ah, 7
	add s_hex[bx], ah
	mov cx, 16
	dec	bx
	jmp convertation_hex
invert_symb_small endp
invert_symb_big proc near
	add dl, 7
	add s_hex[bx], dl
	dec	bx
	jmp convertation_hex
invert_symb_big endp
small_sub_hex proc near
		mov cl, al
		mov s_dec, cx
		cmp ah, 9
		ja 	invert_symb_small
		add s_hex[bx], ah
		mov cx, 16
		dec	bx
		jmp convertation_hex
small_sub_hex endp
big_sub_hex proc near
		mov s_dec, ax
		cmp dl, 9
		ja 	invert_symb_big
		add s_hex[bx], dl
		dec	bx
		jmp convertation_hex
big_sub_hex endp	
convertation_hex:
		mov dx, 0
		mov si, 16
		mov ax, 0
		mov ax, s_dec
		cmp ax, 0
		je out_hex
		div cx
		mov si, dx
		cmp si, 16
		je	small_sub_hex
		cmp si, 16
		jne	big_sub_hex
		ret
convert_dec_to_hex proc near
	mov ax, 0
	mov bx, 3
	mov cx, 16
	call convertation_hex
		
	mov ah, 9
	mov dx, OFFSET s_hex
	int 21h
	ret
convert_dec_to_hex endp

CodeS ENDS
END