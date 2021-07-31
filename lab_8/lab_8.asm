.186
.MODEL TINY
;.DOSSEG
.STACK
.DATA
	MSG DB "Hello!", 0Dh, 0Ah, '$'
.CODE
.STARTUP
testAsm PROC
	mov si, 0
	mov dx, OFFSET MSG
	strlen:
		mov ax, byte ptr[dx + si] 
		cmp al, '!'
		je stop
		inc si
		jmp strlen
	stop: 
		mov dx, 0
		mov dx, si
		add dx, '0'
		mov ah, 2
		int 21h
		
		mov ah, 4ch
		int 21h
ret
testAsm ENDP
call testAsm
END