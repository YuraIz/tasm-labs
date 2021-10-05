.model small
.stack 256
.8086
.data 
a dw ?
b dw ?
c dw ?
d dw ?

;Izmer 053505
;Variant 8.
;if ((a * c) != (b - d)) or (a > d):
;    print(a - b * (c + d))
;else:
;    if ((b - c) > (a + d)) and (a < b):
;        print(b * b - d + c)
;    else:
;        print(2 * c + 3 * d - 5)

.code
main:
	mov ax, @data
	mov ds, ax
	call readnum
	mov a, bx
	call readnum
	mov b, bx
	call readnum
	mov c, bx
	call readnum
	mov d, bx
	mov ax, a
	mul c
	mov bx, b
	sub bx, d
	cmp ax, bx
	jne firsttrue
	mov ax, a
	cmp ax, b
	ja firsttrue
firstfalse:
    mov ax, b
    sub ax, c
    mov bx, a
	add bx, d
	ja secondfalse
	mov ax, a
	cmp ax, b
	jnl secondfalse
secondtrue:
	;print(b * b - d + c)
	mov ax, b
	mul b
	sub ax, d
	add ax, c
	jmp print
secondfalse:
	;print(2 * c + 3 * d - 5)
	mov ax, 3
	mul d
	add ax, c
	add ax, c
	sub ax, 5
	jmp print
firsttrue:
	;print(a - b * (c + d))
	mov ax, c
	add ax, d
	mul b
	mov bx, ax
	mov ax, a
	sub ax, bx
print:
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