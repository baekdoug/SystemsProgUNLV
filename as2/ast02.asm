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

NULL		equ	0	

;------------------------

bVar1		db	30
bVar2		db	19
bAns1		db	0
bAns2		db	0
wVar1		dw	6123
wVar2		dw	2154
wAns1		dw	0
wAns2		dw	0
dVar1		dd	485752666
dVar2		dd	104361210
dVar3		dd	-77700
dAns1		dd	0
dAns2		dd	0
flt1		dd	12.25
flt2		dd	-7.125
pi		    dd	3.14159
qVar1		dq	122169417133
class		db	"CS 218", NULL
iname		db	"Ed Jorgensen", NULL
sname		db	"Doug Baek", NULL





;------------------------

section .text
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