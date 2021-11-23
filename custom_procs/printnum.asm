.model small
.data 
a dw -32768

.code
main:
    mov ax, @data
    mov ds, ax
    mov ax, a
    call printnum
exit:
    mov ah, 04Ch
    mov al, 0
    int 21h
readnum:
    mov ah, 01h
    int 21h
    cmp al, 2dh
    je negative
    call [rpos + 2]
    ret
negative:
    call rpos
    not bx 
    add bx, 1
    ret
rpos:
    mov ah, 01h
    int 21h
    cmp al, 0dh
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
    add ax, 1
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