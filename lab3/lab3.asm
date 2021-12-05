.model small
.stack 512
.data
;error string
    strerr db "wrong input$"
;input string
    max db 20
    len db 0
    buff db 200 dup (0)
;output string
    str2 db 200 dup (0)
.code


error:
    mov ah, 09h
    mov dx, offset strerr
    int 21h
    jmp exit 


checkstr:
    ; pushing registers
    push ax
    push si
    push cx

    mov si, ax
    inc si
    mov al, [si]
    mov ah, 0
    mov cx, ax
    inc si

    push si
    push cx
checksym:
    mov al, [si]
    inc si

    cmp al, 20h; al < ' '
    jl error

    cmp al, 7Ah; al > 'z'
    ja error

    sub al, 21h;
    cmp ax, 20h; ' ' <= al <= 'A'
    jl error

    sub al, 3Ah;
    cmp ax, 6h; 'Z' < al < 'a'
    jl error

    loop checksym

    pop cx
    pop si
checkspaces:
    mov al, [si]
    inc si
    cmp al, 20h; al != ' '
    jne notspace
    inc ah
notspace:
    loop checkspaces

    cmp ah, 1
    jne error

    ; popping registers
    pop cx
    pop si
    pop ax
    ret


thing:
    ; pushing registers
    push bx
    push si
    push cx
    push dx

    mov si, ax
    inc si
    mov al, [si]
    mov ah, 0
    mov cx, ax
    mov di, bx
    mov bx, 0
    inc si
    
    ; get length of first word
    push si
word_len:
    mov al, [si]
    inc si
    inc bx
    cmp ax, 20h
    jne word_len
    pop si

    sub cx, bx
    mov dx, bx
    add dx, si

do_thing:
    mov al, [si]

    push si
    push cx
    mov si, dx

litle_loop:
    cmp al, [si]
    je remove
    inc si
    loop litle_loop
    
    mov [di], al
    inc di
remove:
    pop cx
    pop si
    inc si
    cmp al, 20h
    jne do_thing

    mov al, 24h
    dec di
    mov [di], al

    ; popping registers
    pop dx
    pop cx
    pop si
    pop ax
    ret


main:
    mov ax, @data
    mov ds, ax

    mov ah, 0Ah
    mov dx, offset max
    int 21h
    
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    
    mov ax, offset max
    call checkstr

    mov ax, offset max
    mov bx, offset str2
    call thing

    mov ah, 09h
    mov dx, offset str2
    int 21h

exit:    
    mov ah, 04Ch
    mov al, 0
    int 21h
end main