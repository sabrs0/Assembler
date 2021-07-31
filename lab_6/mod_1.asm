PUBLIC inp_uns_dec
PUBLIC out_bin
PUBLIC out_hex
EXTRN uns_dec_fig: word
EXTRN uns_dec_fig_copy: word
EXTRN uns_bin: byte
EXTRN s_hex: byte
EXTRN sign: byte
EXTRN New_line: byte
EXTRN looper: near


CodeS	SEGMENT	WORD PUBLIC 'CODE'
	ASSUME CS:CodeS
write_numb proc near
		mov uns_dec_fig, bx
		mov uns_dec_fig_copy, bx
		ret
write_numb endp
inp_uns_dec proc near
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
	ret
inp_uns_dec endp
out_bin proc near
	mov ah, 9
	mov dx, OFFSET uns_bin
	int 21h
	
	jmp looper
out_bin endp
out_hex proc near
	mov ah, 9
	mov dx, OFFSET New_line
	int 21h
	mov dl, sign
	mov ah, 2
	int 21h
	mov ah, 9
	mov dx, OFFSET s_hex
	int 21h
	jmp looper
	
	
out_hex endp

CodeS ends
end