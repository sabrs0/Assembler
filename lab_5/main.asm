StkSeg	SEGMENT PARA STACK 'STACK'
		DB		200h DUP (?)
StkSeg ENDS
DataS SEGMENT WORD 'DATA'
	New_Line db 13	
			 db 10 
			 db '$'
	INPUT_ROWS_MSG	db	'Input rows: $'
	INPUT_COLS_MSG	db	'Input columns $'
	INPUT_MATR_MSG	db	'Input matrix $'
	COLS db ?
	ROWS db ?
	REAL_ROWS db ?
	Matr	db 81 DUP('0')
	CYC_STEP dw 0
	CYC_STEP2 dw 0
	CYC_STEP3 dw 0
	CYC_STEP4 dw 0
DataS ENDS
CodeS SEGMENT WORD 'CODE'
	ASSUME	CS:CodeS, DS:DataS, SS:StkSeg
matr_init:
	mov dx, OFFSET INPUT_ROWS_MSG
	mov ah, 9
	int 21h
	mov cx, 0

	
	mov ah, 1
	int 21h
	mov ROWS, al
	sub ROWS, '0'
	
	mov dx, OFFSET New_Line
	mov ah, 9
	int 21h
	
	mov dx, OFFSET INPUT_COLS_MSG
	mov ah, 9
	int 21h
	
	mov ah, 1
	int 21h
	mov COLS, al
	sub COLS, '0'
	
	mov dx, OFFSET New_Line
	mov ah, 9
	int 21h
	
	mov dx, OFFSET INPUT_MATR_MSG
	mov ah, 9
	int 21h
	
	mov dx, OFFSET New_Line
	mov ah, 9
	int 21h
	
	mov cl, ROWS
	mov bx, 0
	INIT_MATR:
		mov cl, COLS
			INIT_ROWS:
				mov ah, 1
				int 21h
				mov Matr[bx], al
				inc bx
				
				mov ah, 2
				mov dl, ' '
				int 21h
				
				loop INIT_ROWS
			mov dx, OFFSET New_Line
			mov ah, 9
			int 21h
			
			mov cl, ROWS
			
			mov si, CYC_STEP
			
			sub cx, si
			
			inc CYC_STEP
			
			mov ax,	CYC_STEP
			
			mov dx, 9
			
			mul dl
			
			mov bx, ax
			
			loop INIT_MATR
			
	mov al, ROWS
	mov REAL_ROWS, al
	ret
EXIT:
	mov ah, 4ch
	int 21h
out_matr:

	mov ax, 0
	mov CYC_STEP2, ax
	
	mov dx, OFFSET New_Line
	mov ah, 9
	int 21h
	
	mov cl, REAL_ROWS
	mov bx, 0
	
	cmp cl, 0
	je EXIT
	cmp cl, 0
	jne OUT_VNESH
	OUT_VNESH:
		mov cl, COLS
			OUT_VNUTR:
				mov dl, Matr[bx]
				mov ah, 2
				int 21h
				inc bx
				
				mov ah, 2
				mov dl, ' '
				int 21h
				
				loop OUT_VNUTR
		mov dx, OFFSET New_Line
		mov ah, 9
		int 21h
			
		mov cl, REAL_ROWS
			
		mov si, CYC_STEP2
			
		sub cx, si
			
		inc CYC_STEP2
			
		mov ax,	CYC_STEP2
			
		mov dx, 9
		
		mul dl
			
		mov bx, ax
		
		loop OUT_VNESH
	
	
	jmp EXIT
del_row:
	mov ax, 0
	mov CYC_STEP4, ax
	mov al, REAL_ROWS
	sub ax, CYC_STEP3
	mov cl, al
	
	DEL_VNESH:
		mov cl, COLS
		mov si, bx
		add si, 9
		DEL_VNUTR:
			mov al, Matr[si]
			mov Matr[bx], al
			inc bx
			inc si
			loop DEL_VNUTR
			
		mov al, REAL_ROWS
		sub ax, CYC_STEP3
		mov cl, al
		mov si, CYC_STEP4
			
		sub cx, si
			
		inc CYC_STEP4	
			
		mov ax,	CYC_STEP4
		
		add ax, CYC_STEP3
		
		mov dx, 9
			
		mul dx
			
		mov bx, ax
		loop DEL_VNESH
	mov bx, 0
	jmp process
			
check_row:
		mov ax, CYC_STEP3
		mov dx, 9h
		mul dx
		mov bx, ax
		
		mov ax, CYC_STEP3
		dec REAL_ROWS
		mov dl, REAL_ROWS
		cmp al, dl
		je  out_matr
		cmp al, dl
		jne DEL_ROW
		
process:
	mov ax, 0
	mov CYC_STEP3, ax
	mov cl, REAL_ROWS
	mov bx, 0
	ROW_SRCH:
		mov cl, COLS
			COL_SRCH:
				
				mov dl, '0'
				cmp Matr[bx], dl
				je	check_row
				inc bx
				loop COL_SRCH
			
			mov cl, REAL_ROWS
			
			mov si, CYC_STEP3
			
			sub cx, si
			
			inc CYC_STEP3
			
			mov ax,	CYC_STEP3
			
			mov dl, 9
			
			mul dl
			
			mov bx, ax
			
			loop ROW_SRCH
	
	jmp out_matr
	
main:
	mov	ax,DataS
	
	mov ds, ax
	
	call matr_init
	
	call process
	
	call out_matr
			
	
CodeS	ENDS
		END		main