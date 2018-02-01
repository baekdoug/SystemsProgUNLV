;Doug Baek
;Sec 01
;Assignment 4


section	.data
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----

lst			dd	1, 2, 3, 4, 5
		
length		dd	5

lstMin		dd	0
lstMid		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

evenCnt		dd	0
evenSum		dd	0
evenAve		dd	0

tenCnt		dd	0
tenSum		dd	0
tenAve		dd	0


;****************************************************

section	.text
global _start
_start:

mov ecx, 0
mov ecx, dword[length]
dec ecx
mov r9d, 0
mov r9d, dword[ebx + (ecx * 4)]
mov dword[lstMin], r9d
mov r9d, 0
mov r9d, dword[ebx + (ecx * 4)]
mov dword[lstMax], r9d
mov rbx, 0
mov ebx, lst

mainLp:


mov r9d, 0

mov r9d, dword[lstMin]
mov r10d, 0
mov r10d, dword[ebx + (ecx * 4)]
cmp r9d, r10d
jl skipMin
mov r9d, dword[ebx + (ecx * 4)]
mov dword[lstMin], r9d


skipMin:
mov r9d, dword[lstMax]
cmp r9d, dword[ebx + (ecx * 4)]
jg skipMax
mov r9d, dword[ebx + (ecx * 4)]
mov dword[lstMax], r9d

skipMax:

mov rax, 0
mov eax, dword[lstSum]
add eax, dword[ebx + (ecx * 4)]
mov dword[lstSum], eax

mov eax, 0
mov edx, 0
mov eax, dword[ebx + (ecx * 4)]
cdq
mov r10, 0
mov r10, 2
idiv r10d
cmp edx, 0
jne notEven
mov eax, 0
mov eax, dword[evenCnt]
add eax, 1
mov dword[evenCnt], eax

mov eax, 0
mov eax, dword[ebx + (ecx * 4)]
add eax, dword[evenSum]
mov dword[evenSum], eax
mov eax, 0


notEven:

mov rax, 0
mov eax, dword[ebx + (ecx * 4)]
cdq
mov r10, 0
mov r10d, 10
idiv r10d
cmp edx, 0
jne notTen
mov eax, 0
mov eax, dword[tenCnt]
add eax, 1
mov dword[tenCnt], eax

mov eax, dword[ebx + (ecx * 4)]
add eax, dword[tenSum]
mov dword[tenSum], eax

notTen:

dec ecx
cmp ecx, 0
jge mainLp

mov rax, 0
mov rdx, 0
mov eax, dword[lstSum]
cdq 
idiv dword[length]
mov dword[lstAve], eax

mov rax, 0
mov rdx, 0
mov eax, dword[evenSum]
cdq
idiv dword[evenCnt]
mov dword[evenAve], eax

mov rax, 0
mov rdx, 0
mov eax, dword[tenSum]
cdq
idiv dword[tenCnt]
mov dword[tenAve], eax

mov rax, 0
mov rdx, 0
mov rcx, 0

mov eax, dword[length]
mov ecx, 2
div ecx

cmp edx, 0
jne isOdd

mov ecx, 0 
mov ecx, dword[ebx + (eax * 4)]
inc eax
add ecx, dword[ebx + (eax * 4)]
mov rax, 0
mov rdx, 0

mov eax, ecx
mov ecx, 2
cdq
idiv ecx
mov dword[lstMid], eax


jmp finishThis
isOdd:

mov rax, 0
mov eax, dword[length]
mov rcx, 0
mov ecx, 2
div ecx
inc eax
mov ecx, 0
mov ecx, dword[ebx + (eax * 4)]
mov dword[lstMid], ecx

finishThis:




last:
	mov	eax, SYS_exit		; call code for exit
	mov	ebx, EXIT_SUCCESS	; exit program with success
	syscall