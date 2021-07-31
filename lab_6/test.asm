EXTRN inp_uns_dec: near
EXTRN convert_bin: near
EXTRN compare_vals: near
EXTRN zero_bin: near
PUBLIC New_line
PUBLIC uns_dec_fig
PUBLIC uns_dec_fig_copy
PUBLIC uns_bin
PUBLIC s_dec
PUBLIC s_hex
PUBLIC sign
PUBLIC looper

Stkseg SEGMENT PARA STACK 'STACK'
	DB		200h DUP (?)
Stkseg ENDS

Menuseg SEGMENT PARA PUBLIC 'DATA'
	New_line db 13
			 db 10
			 db '$'
	MSG	db 13 
		db 10
		db	'1 - input Unsigned 10'
		db 13 
		db 10
		db	'2 - Output unsigned 2 ns'
		db 13
		db 10
		db	'3 - output signed 16 ns'
		db 13 
		db 10
		db	'0 - Exit'
		db 13
		db 10
		db '$'
	acts dw exit, inp_uns_dec, ft_action, scnd_action
	uns_dec_fig dw 0
	uns_dec_fig_copy dw 0
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
CodeS	SEGMENT	WORD PUBLIC 'CODE'
	ASSUME CS:CodeS, DS:Menuseg, SS:StkSeg
		
ft_action:
	call zero_bin
	call convert_bin
	ret

scnd_action:
	call compare_vals
	ret

	
get_action:
	mov si, 0
	mov ah, 1
	int 21h
	mov ah, 0
	mov si, ax
	sub si, '0'
	mov ax, si
	mov cx, 2
	mul cx
	mov si, ax
	mov ax, uns_dec_fig_copy
	mov uns_dec_fig, ax
	call acts[si]
	
	ret
exit:	
	mov ah, 4ch
	int 21h
looper proc near
		cyc:
			mov dx, OFFSET MSG
			mov ah, 9
			int 21h
			call get_action
			jmp cyc
looper endp
main:
	mov ax, Menuseg
	mov ds, ax
	
	call looper
	call exit
CodeS ENDS
	END	main