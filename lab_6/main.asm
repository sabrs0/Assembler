Stkseg SEGMENT PARA STACK 'STACK'
	DB		200h DUP (?)
Stkseg ENDS

Menuseg SEGMENT WORD 'DATA'
	New_line db 13
			 db 10
			 db '$'
	MSG	db 13 
		db 10
		db	'1 - input Unsigned 10 ns and output unsigned 2 ns'
		db 13
		db 10
		db	'2 - input Unsigned 10 ns and output signed 16 ns'
		db 13
		db 10
		db '$'
	act	db 0
	uns_dec_fig dw 0
	uns_bin	db 13
			db 10
			db	16 dup ('0')
			db '$'
	s_dec	dw 0
	;s_hex	;db 13
			;db 10
	s_hex	db	4 dup ('0')
			db '$'
	sign	db '+'
Menuseg ENDS
CodeS	SEGMENT	WORD 'CODE'
	ASSUME CS:CodeS, DS:Menuseg, SS:StkSeg
inp_uns_dec:
	mov ah, 9
	mov dx, OFFSET New_line
	int 21h


	mov cx, 0
	mov bx, 0
	mov si, 0
	mov ax, 0
	char_to_numb:
		mov ah, 1
		int 21h
		cmp al, 13
		je	write_numb
		mov ah, 0
		mov si, ax
		mov ax, 10
		mov dx, cx
		mul dx
		mul bx
		mov bx, ax
		sub si, '0'
		add bx, si
		mov cx, 1
		jmp char_to_numb
	write_numb:
		mov uns_dec_fig, bx
		;mov ah, 2
		;mov dx, uns_dec_fig
		;int 21h
		ret
out_bin:
	mov ah, 9
	mov dx, OFFSET uns_bin
	int 21h
	
	mov ah, 4ch
	int 21h
out_hex:
	mov dl, sign
	mov ah, 2
	int 21h
	
	mov ah, 9
	mov dx, OFFSET s_hex
	int 21h
	
	mov ah, 4ch
	int 21h
small_sub:
		mov cx, 0
		mov cl, al
		mov uns_dec_fig, cx
		add uns_bin[bx], ah
		mov cx, 2
		dec	bx
		jmp convertation_bin
big_sub:
		mov uns_dec_fig, ax
		add uns_bin[bx], dl
		dec	bx
		jmp convertation_bin
convert_bin:
	mov ax, 0
	mov bx, 17
	mov cx, 2
	convertation_bin:
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
		
	mov ah, 9
	mov dx, OFFSET uns_bin
	int 21h
	ret
make_usual_get:
	mov ax, uns_dec_fig
	mov s_dec, ax
	jmp convert_dec_to_hex
compare_vals:
	cmp uns_dec_fig, 32767
	ja	inverse_bin
	cmp uns_dec_fig, 32767
	jna	make_usual_get
inverse_bin:
	mov sign, '-'
	mov ax, uns_dec_fig
	not ax
	inc ax
	mov s_dec, ax
	jmp convert_dec_to_hex
invert_symb_small:
	add ah, 7
	add s_hex[bx], ah
	mov cx, 16
	dec	bx
	jmp convertation_hex
invert_symb_big:
	add dl, 7
	add s_hex[bx], dl
	dec	bx
	jmp convertation_hex
small_sub_hex:
		mov cl, al
		mov s_dec, cx
		cmp ah, 9
		ja 	invert_symb_small
		add s_hex[bx], ah
		mov cx, 16
		dec	bx
		jmp convertation_hex
big_sub_hex:
		mov s_dec, ax
		cmp dl, 9
		ja 	invert_symb_big
		add s_hex[bx], dl
		dec	bx
		jmp convertation_hex	
convert_dec_to_hex:
	mov ax, 0
	mov bx, 3
	mov cx, 16
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
		
	mov ah, 9
	mov dx, OFFSET s_hex
	int 21h
	ret
		
ft_action:
	call inp_uns_dec
	call convert_bin
	ret

scnd_action:
	call inp_uns_dec
	call compare_vals
	ret

	
get_action:
	mov ah, 1
	int 21h
	mov act, al
	cmp act, '1'
	je ft_action
	cmp act, '2'
	je scnd_action
	
	ret
main:
	mov ax, Menuseg
	mov ds, ax
	
	mov dx, OFFSET MSG
	mov ah, 9
	int 21h
	;call ft_action
	call get_action
	;call inp_uns_dec
	
	mov ah, 4ch
	int 21h
CodeS ENDS
	END	main