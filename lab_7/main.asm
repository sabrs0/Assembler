.MODEL TINY
.186

CODES SEGMENT
    ASSUME CS:CODES, DS:CODES
    ORG 100H
MAIN:
	jmp init
	cur_sec db 0
	cur_speed db 01fh
	old_08h dd ?
	FLAG db 13

new_08h proc
    pusha
    push es
    push ds

    mov ah, 02h 
    int 1ah	

    cmp dh, cur_sec
    mov cur_sec, dh
    je end_loop

    mov al, 0f3h 
    out 60h, al 
    mov al, cur_speed
    out 60h, al 

    dec cur_speed
    test cur_speed, 01fh
    jz reset
    jmp end_loop

    reset:
        mov cur_speed, 01fh

    end_loop:
        pop ds
        pop es
		
        popa

        jmp CS:old_08h

new_08h endp

init:
    mov AX, 3508h 
    int 21h

    cmp ES:FLAG, 13
    je uninstall

    mov word ptr old_08h, BX
    mov word ptr old_08h + 2, ES

    mov AX, 2508h
	
    mov DX, offset new_08h
    int 21h

    mov DX, offset INSTALL_MSG
    mov AH, 9
    int 21h

    mov DX, offset init
    int 27H

uninstall:
    push ES
    push DS

    mov al, 0F3h
    out 60h, al
    mov al, 0
    out 60h, al

    mov dx, word ptr ES:old_08h
    mov ds, word ptr ES:old_08h + 2
    mov ax, 2508h
    int 21h

    pop ds
    pop es

    mov ah, 49h
    int 21h

    mov dx, offset UNINSTALL_MSG
    mov ah, 9h
    int 21h

    mov ax, 4C00h
    int 21h

    INSTALL_MSG   db 'Installation$'
    UNINSTALL_MSG db 'Uninstallation$'

CODES ENDS
END MAIN
