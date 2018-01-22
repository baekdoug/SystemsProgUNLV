; *****************************************************************
;  Must include:
;	name : Douglas Baek
;	assignmnet # 3
;	section # 01

; -----
;  Write a simple assembly language program to compute the
;  the provided formulas.

;  Focus on learning basic arithmetic operations
;  (add, subtract, multiply, and divide).
;  Ensure understanding of sign and unsigned operations.

; *****************************************************************
;  Data Declarations (provided).

section	.data
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data
bNum1		db	35
bNum2		db	17
bNum3		db	15
bNum4		db	11
bNum5		db	-39
bNum6		db	-19
bAns1		db	0
bAns2		db	0
bAns3		db	0
bAns4		db	0
bAns5		db	0
bAns6		db	0
bAns7		db	0
bAns8		db	0
bAns9		db	0
bAns10		db	0
wAns11		dw	0
wAns12		dw	0
wAns13		dw	0
wAns14		dw	0
wAns15		dw	0
bAns16		db	0
bAns17		db	0
bAns18		db	0
bRem18		db	0
bAns19		db	0
bAns20		db	0
bAns21		db	0
bRem21		db	0

; word data
wNum1		dw	315
wNum2		dw	145
wNum3		dw	5183
wNum4		dw	2198
wNum5		dw	-576
wNum6		dw	-168
wAns1		dw	0
wAns2		dw	0
wAns3		dw	0
wAns4		dw	0
wAns5		dw	0
wAns6		dw	0
wAns7		dw	0
wAns8		dw	0
wAns9		dw	0
wAns10		dw	0
dAns11		dd	0
dAns12		dd	0
dAns13		dd	0
dAns14		dd	0
dAns15		dd	0
wAns16		dw	0
wAns17		dw	0
wAns18		dw	0
wRem18		dw	0
wAns19		dw	0
wAns20		dw	0
wAns21		dw	0
wRem21		dw	0

; double-word data
dNum1		dd	13456789
dNum2		dd	31342
dNum3		dd	219815
dNum4		dd	61569
dNum5		dd	-703
dNum6		dd	-5249
dAns1		dd	0
dAns2		dd	0
dAns3		dd	0
dAns4		dd	0
dAns5		dd	0
dAns6		dd	0
dAns7		dd	0
dAns8		dd	0
dAns9		dd	0
dAns10		dd	0
qAns11		dq	0
qAns12		dq	0
qAns13		dq	0
qAns14		dq	0
qAns15		dq	0
dAns16		dd	0
dAns17		dd	0
dAns18		dd	0
dRem18		dd	0
dAns19		dd	0
dAns20		dd	0
dAns21		dd	0
dRem21		dd	0

; quadword data
qNum1		dq	24656793
qNum2		dq	115732
qNum3		dq	1526241
qNum4		dq	254879
qNum5		dq	-27517
qNum6		dq	-312759
qAns1		dq	0
qAns2		dq	0
qAns3		dq	0
qAns4		dq	0
qAns5		dq	0
qAns6		dq	0
qAns7		dq	0
qAns8		dq	0
qAns9		dq	0
qAns10		dq	0
dqAns11		ddq	0
dqAns12		ddq	0
dqAns13		ddq	0
dqAns14		ddq	0
dqAns15		ddq	0
qAns16		dq	0
qAns17		dq	0
qAns18		dq	0
qRem18		dq	0
qAns19		dq	0
qAns20		dq	0
qAns21		dq	0
qRem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ----------------------------------------------
; Byte Operations

; unsigned byte additions
;	bAns1  = bNum1 + bNum2
	mov al, byte[bNum1]
	add al, byte[bNum2]
	mov byte[bAns1], al

;	bAns2  = bNum1 + bNum3
	mov al, byte[bNum1]
	add al, byte[bNum3]
	mov byte[bAns2], al
;	bAns3  = bNum3 + bNum4
	mov al, byte[bNum3]
	add al, byte[bNum4]
	mov byte[bAns2], al

; -----
; signed byte additions
;	bAns4  = bNum5 + bNum6
	movsx al, byte[bNum5]
	add al, byte[bNum6]
	movsx byte[bAns4], al
;	bAns5  = bNum1 + bNum6
	movsx al, byte[bNum1]
	add al, byte[bNum6]
	movsx byte[bAns5], al 

; -----
; unsigned byte subtractions
;	bAns6  = bNum1 - bNum2
	mov al, byte[bNum1]
	sub al, byte[bNum2]
	mov byte[bAns6], al 

;	bAns7  = bNum1 - bNum3
	mov al, byte[bNum1]
	sub al, byte[bNum3]
	mov byte[bAns7], al

;	bAns8  = bNum2 - bNum4
	mov al, byte[bNum2]
	sub al, byte[bNum4]
	mov byte[bAns8], al



; -----
; signed byte subtraction
;	bAns9  = bNum6 - bNum5
;	bAns10 = bNum5 - bNum2



; -----
; unsigned byte multiplication
;	wAns11  = bNum1 * bNum3
	mov al, byte[bNum1]
	mul byte[bNum3]
	mov word[wAns11], ax
;	wAns12  = bNum2 * bNum2
	mov al, byte[bNum2]
	mul al
	mov word[wAns12], ax
;	wAns13  = bNum2 * bNum4
	mov al, byte[bNum2]
	mul byte[bNum4]
	mov word[wAns13], ax



; -----
; signed byte multiplication
;	wAns14  = bNum5 * bNum5
;	wAns15  = bNum1 * bNum5



; -----
; unsigned byte division
;	bAns16 = bNum1 / bNum2
;	bAns17 = bNum3 / bNum4
;	bAns18 = wNum1 / bNum4
;	bRem18 = wNum1 % bNum4



; -----
; signed byte division
;	bAns19 = bNum5 / bNum6
;	bAns20 = bNum6 / bNum3
;	bAns21 = wNum6 / bNum4
;	bRem21 = wNum6 % bNum4




; *****************************************
; Word Operations

; -----
; unsigned word additions
;	wAns1  = wNum1 + wNum3
;	wAns2  = wNum2 + wNum4
;	wAns3  = wNum3 + wNum2



; -----
; signed word additions
;	wAns4  = wNum5 + wNum6
;	wAns5  = wNum1 + wNum6



; -----
; unsigned word subtractions
;	wAns6  = wNum1 - wNum2
;	wAns7  = wNum3 - wNum4
;	wAns8  = wNum2 - wNum4



; -----
; signed word subtraction
;	wAns9  = wNum5 - wNum6
;	wAns10  = wNum2 - wNum6



; -----
; unsigned word multiplication
;	dAns11 = wNum1 * wNum2
;	dAns12  = wNum2 * wNum4
;	dAns13  = wNum3 * wNum3



; -----
; signed word multiplication
;	dAns14  = wNum5 * wNum6
;	dAns15  = wNum5 * wNum2



; -----
; unsigned word division
;	wAns16 = wNum1 / wNum2
;	wAns17 = wNum3 / wNum4
;	wAns18 = dNum4 / wNum1
;	wRem18 = dNum4 % wNum1



; -----
; signed word division
;	wAns19 = wNum5 / wNum6
;	wAns20 = wNum1 / wNum5
;	wAns21 = dNum6 / wNum2
;	wRem21 = dNum6 % wNum2




; *****************************************
; Double-Word Operations

; -----
; unsigned double-word additions
;	dAns1  = dNum1 + dNum2
;	dAns2  = dNum2 + dNum3
;	dAns3  = dNum4 + dNum2



; -----
; signed double-word additions
;	dAns4  = dNum6 + dNum5 
;	dAns5  = dNum6 + dNum1



; -----
; unsigned double-word subtractions
;	dAns6  = dNum1 - dNum3
;	dAns7  = dNum3 - dNum4
;	dAns8  = dNum2 - dNum3



; -----
; signed double-word subtraction
;	dAns9  = dNum6 - dNum5
;	dAns10 = dNum2 – dNum5



; -----
; unsigned double-word multiplication
;	qAns11  = dNum1 * dNum3
;	qAns12  = dNum2 * dNum3
;	qAns13  = dNum3 * dNum4



; -----
; signed double-word multiplication
;	qAns14  = dNum5 * dNum2
;	qAns15  = dNum5 * dNum5



; -----
; unsigned double-word division
;	dAns16 = dNum1 / dNum2
;	dAns17 = dNum3 / dNum4
;	dAns18 = qAns11 / dNum4
;	dRem18 = qAns11 % dNum4



; -----
; signed double-word division
;	dAns19 = dNum6 / dNum5
;	dAns20 = dNum1 / dNum5
;	dAns21 = qAns12 / dNum6
;	dRem21 = qAns12 % dNum6




; *****************************************
; QuadWord Operations

; -----
; unsigned quadword additions
;	qAns1  = qNum2 + qNum3
;	qAns2  = qNum1 + qNum4
;	qAns3  = qNum4 + qNum2



; -----
; signed quadword additions
;	qAns4  = qNum6 + qNum5
;	qAns5  = qNum1 + qNum5



; -----
; unsigned quadword subtractions
;	qAns6  = qNum2 - qNum3
;	qAns7  = qNum1 - qNum4
;	qAns8  = qNum2 - qNum3



; -----
; signed quadword subtraction
;	qAns9  = qNum6 - qNum5
;	qAns10 = qNum6 - qNum2



; -----
; unsigned quadword multiplication
;	dqAns11  = qNum3 * qNum2
;	dqAns12  = qNum3 * qNum3
;	dqAns13  = qNum4 * qNum1



; -----
; signed quadword multiplication
;	dqAns14  = qNum1 * qNum6
;	dqAns15  = qNum5 * qNum6



; -----
; unsigned quadword division
;	qAns16 = qNum1 / qNum2
;	qAns17 = qNum3 / qNum4
;	qAns18 = dqAns11 / qNum4
;	qRem18 = dqAns11 % qNum4



; -----
; signed quadword division
;	qAns19 = qNum6 / qNum5
;	qAns20 = qNum2 / qNum5
;	qAns21 = dqAns12 / qNum6
;	qRem21 = dqAns12 % qNum6




; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call call for exit (SYS_exit)
	mov	ebx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall

