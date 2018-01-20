;   Douglas Baek
;   Assignment 02
;   Section 1001

;*******************************************************************************************

section .data

;   Standard Constants

TRUE        equ 1
FALSE       equ 0

EXIT_SUCCESS    equ 0
SYS_exit        equ 60

;------------------------

bAns1   db  0
bAns2   db  0
bVar1   db  0
bVar2   db  0

wAns1   dw  0
wAns2   dw  0
wVar1   dw  0
wVar2   dw  0

dAns1   dd  0
dAns2   dd  0
dVar1   dd  0
dVar2   dd  0



;------------------------

section . text
global _start
_start:


    mov	al, byte[bVar1]
    add	al, byte[bVar2]
    mov	byte[bAns1],al
;
    mov	al, byte[bVar1]
    sub	al, byte[bVar2]
    mov	byte[bAns2], al
;
    mov	ax, word[wVar1]
    add	ax, word[wVar2]
    mov	word[wAns1], ax
;
    mov	ax, word[wVar1]
    sub	ax, word[wVar2]
    mov	word[wAns2], ax
;
    mov	eax, dword[dVar1]
    add	eax, dword[dVar2]
    mov	dword[dAns1], eax
;
    mov	eax, dword[dVar1]
    sub	eax, dword[dVar2]
    mov	dword[dAns2], eax
;
last:
    mov eax, SYS_exit
    mov ebx, EXIT_SUCCESS
    syscall