.model small
.stack 256
.8086

;Izmer 053505
;Variant 1
;Minimum divisor of a number

.code
main:
    call readnum
    mov cx, 1
    cmp bx, 0
    jns cycle
    not bx
    inc bx
cycle:
    mov dx, 0
    mov ax, bx
    inc cx
    div cx
    cmp dl, 0
    jz p
    cmp bx, cx
    jnl cycle
    mov cx, bx
p:
    mov ax, cx
    call printnum
exit:
    mov ah, 04Ch
    mov al, 0
    int 21h
readnum:
    mov bx, 0
    mov ah, 01h
    int 21h
    cmp al, 2dh
    je negative
    call analyze
    ret
negative:
    call rpos
    not bx 
    inc bx
    ret
rpos:
    mov ah, 01h
    int 21h
analyze:
    cmp al, 0dh
    je endl
    cmp al, 10
    je endl
    sub al, 48
    mov ah, 0
    push ax
    mov ax, 10
    mul bx
    mov bx, ax
    pop ax
    add bx, ax
    call rpos
endl:
    ret
printnum:
    cmp ax, 0
    jz pzero
    jnl ppos
    mov dl, '-'
    push ax
    mov ah, 02h
    int 21h
    pop ax
    not ax 
    inc ax
ppos:
;used: ax dx bx 
    cmp ax, 0
    jz zero
    mov dx, 0
    mov bx, 10
    div bx    
    add dl, 48
    push dx
    call ppos
    pop dx
    push ax
    mov ah, 02h
    int 21h
    pop ax
zero:
    ret
pzero:
    mov dl, 30h
    mov ah, 02h
    int 21h
    ret
end main