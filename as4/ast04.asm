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

lst		dd	 1, 2, 3, 4, 5
		
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
mov rbx, 0
mov ebx, lst

mainLp:


mov r9d, 0

mov r9d, dword[lstMin]
cmp r9d, dword[ebx + (ecx * 4)]
jl skipMin
mov dword[lstMin], r9d

skipMin:
mov r9d, dword[lstMax]
cmp r9d, dword[ebx + (ecx * 4)]
jg skipMax
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
idiv 2
cmp edx, 0
jne notEven
mov eax, 0
mov eax, dword[evenCnt]
add eax, 1
mov dword[evenCnt], eax

mov eax, dword[ebx + (ecx * 4)]
add eax, dword[evenSum]
mov dword[evenSum], eax


notEven:

mov rax, 0
mov eax, dword[ebx + (ecx * 4)]
cdq
idiv 10
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

cmp ecx, 0
jne mainLp









last:
	mov	eax, SYS_exit		; call code for exit
	mov	ebx, EXIT_SUCCESS	; exit program with success
	syscall