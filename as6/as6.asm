;  CS 218, Assignment #6
;  Provided Main

;  Write a simple assembly language program to:
;	convert base-36/ASCII charatcers into an integer
;	convert an integer to base-36/ASCII charatcers


; **********************************************************************************
;  STEP #3
;  Macro, "b362int", to convert a base-36/ASCII string
;  into an unsigned integer.  The macro reads the ASCII string (byte-size,
;  NULL terminated) and converts to a doubleword sized integer.
;	- Accepts both upper and lower case (which are treated as the same thing).
;	- Assumes valid/correct data.  As such, no error checking is performed.
;  Skips leading blanks.

;  Example:  given the ASCII string: " 7CLZI", NULL
;  The is,  " " (blank), followed by "7", followeed by "C", followed
;  by "L", followed by "Z", followed by "I" and NULL would be
;  converted to integer 12345678.

; -----
;  Arguments
;	%1 -> string address (reg)
;	%2 -> integer number (destination address)


%macro	b362int	2
	push	rax
	push	rcx
	push	rsi
	push	rdi


;	YOUR CODE GOES HERE


	pop	rdi
	pop	rsi
	pop	rcx
	pop	rax
%endmacro

; **********************************************************************************
;  STEP #4
;  Macro, "int2b36", to convert an unsigned base-10 integer into an
;  ASCII string representing the undecimal value.  The macro stores
;  the result into an ASCII string (byte-size, right justified,
;  blank filled, NULL terminated).  Each integer is a doubleword value.
;  Assumes valid/correct data.  As such, no error checking is performed.

; -----
;  Arguments
;	%1 -> integer number
;	%2 -> string address

%macro	int2b36	2
	push	rax
	push	rbx
	push	rcx
	push	rdx
	push	rsi
	push	rdi


;	YOUR CODE GOES HERE


	pop	rdi
	pop	rsi
	pop	rdx
	pop	rcx
	pop	rbx
	pop	rax
%endmacro

; --------------------------------------------------------------
;  Simple macro to display a string to the console.
;	Call:	printString  <stringAddr>

;	Arguments:
;		%1 -> <stringAddr>, string address

;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	mov	rsi, %1			; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; --------------------------------------------------------------

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Variables and constants.

MAX_STR_SIZE	equ	10			; note, includes the NULL
NUMS_PER_LINE	equ	5

newline		db	LF, NULL

; -----
;  Misc. string definitions.

hdr1		db	"--------------------------------------------"
		db	LF, "CS 218 - Assignment #6", LF
		db	LF, NULL
hdr2		db	LF, LF, "----------------------"
		db	LF, "List Sums"
		db	LF, NULL

firstNum	db	"----------------------", LF
		db	"Test Number (base-36):      ", NULL
firstNumMul	db	"Test Number * 5 (base-36): ", NULL

lstSum1		db	LF, "List Sum (short list):"
		db	LF, NULL
lstSum2		db	LF, "List Sum (long list):"
		db	LF, NULL

; -----
;  Misc. data definitions (if any).



; -----
;  Assignment #6 Provided Data:

uStr1		db	"    7CLZI", NULL
iNum1		dd	0

dStrLst1	db	"     1C9H", NULL, "   3AbQT1", NULL, "   1RtQY2", NULL
		db	"    82AZ3", NULL, "   CLwy13", NULL
len1		dd	5
sum1		dd	0

dStrLst2	db	"      3W8", NULL, "    X6KP1", NULL, "    1gkjd", NULL
		db	"   2KD0W0", NULL, "    AJNSS", NULL, "    1fsa0", NULL
		db	"    224d2", NULL, "    A1ef0", NULL, "    12301", NULL
		db	"     MDKL", NULL, "        a", NULL, "       36", NULL
		db	"      7x1", NULL, "    Rx009", NULL, "     ajd8", NULL
		db	"    HELLO", NULL, "    v23X9", NULL, "   qz1kjh", NULL
		db	"     1BYE", NULL, "    1TRM1", NULL, "    r1GFW", NULL
		db	"    2FRED", NULL, "    HJEEq", NULL, "    31kmq", NULL
		db	"     ANdy", NULL, "    WAXER", NULL, "    st420", NULL
		db	"    HOMER", NULL, "    2JHW6", NULL, "    q5182", NULL
len2		dd	30
sum2		dd	0


; **********************************************************************************

section	.bss

num1String	resb	MAX_STR_SIZE
tempString	resb	MAX_STR_SIZE
tempNum		resd	1


; **********************************************************************************

section	.text
global	_start
_start:

; **********************************************************************************
;  Main program
;	display headers
;	performs conversions (not using macro)
;	loops to call the macro on various data items
;	display results to screen (via provided macro's)

;  Note, since the print macros do NOT perform an error checking,
;  	if the conversion macros do not work correctly,
;	the print string will not work!

; **********************************************************************************
;  Prints some cute headers...

	printString	hdr1
	printString	firstNum
	printString	uStr1
	printString	newline

; -----
;  STEP #1
;	Convert base-36/ASCII NULL terminated string at
;	'uStr1' into an integer which should be placed into 'iNum1'
;	Note, 7CLZI (base-36) = 12,345,678 (base-10)
;	DO NOT USE MACRO HERE!!



;	YOUR CODE GOES HERE

mov rax, 0
mov rcx, 0
mov r10, 0
b36conLP:
mov rax, 0
mov al, byte[uStr1 + ecx]
cmp al, " "
je isSpaceEnd
cmp al, NULL
je finishThis
mov byte[tempString + r10d], al
inc r10d
isSpaceEnd:
inc ecx
jmp b36conLP

finishThis:

mov rax, 0
mov rbx, 0
mov r9, 0
mov rcx, 0
mov ecx, r10d

convLp:
mov ebx, ecx
movzx r9d, byte[tempString + ecx]
cmp r9d, "A"
jge isAlpha
sub r9d, "0"
jmp mulLp
isAlpha:
sub r9d,"A"
add r9d, 10
mov r10d, 0
mov r10d, 10
mov rax, 0
mov eax, r9d
mulLp:
cmp ebx, 0
je isZero
mul r10d


dec ebx
cmp ebx, 0
jne mulLp

add dword[iNum1], eax

dec ecx
cmp ecx, 0
jg convLp

isZero:
add dword[iNum1], eax



; -----
;  Perform (iNum1 * 5) operation.
;	Note, 12,345,678 (base-10) * 5 (base-10) = 61,728,390 (base-10)

	mov	eax, dword [iNum1]
	mov	ebx, 5
	imul	ebx
	mov	dword [iNum1], eax

; -----
;  STEP #2
;	Convert the base-10 integer (iNum1) into a base-36/ASCII string
;	which should be stored into the 'num1String'
;	Note, 61,728,390 (base-10) = 10R1XI (base-36)
;	DO NOT USE MACRO HERE!!


;	YOUR CODE GOES HERE

mov rax, 0
mov rbx, 0
mov rcx, 0
mov rdx, 0
mov r9, 0
mov r9d, 36
mov eax, dword[iNum1]


convert2Int:
div r9d 
mov dword[tempNum], edx
mov rdx, 0
mov bl, byte[tempNum]
cmp bl, 10
jge isAlphaInt

add bl, "0"
mov byte[tempString + ecx], bl
inc ecx

jmp doneInt
isAlphaInt:

sub bl, 10
add bl, "A"
mov byte[tempString + ecx], bl
inc ecx


doneInt:
cmp eax, 0
jne convert2Int
mov r9, 0

moveToString:
mov rax, 0
mov al, [tempString + ecx]
mov byte[num1String + r9], al

inc r9
dec ecx
cmp ecx, 0
jg moveToString



; -----
;  Display a simple header and then the ASCII/undecimal string.

	printString	firstNumMul
	printString	num1String


; **********************************************************************************
;  Next, loop to repeatedly call the macro on each value in an array.

	printString	hdr2

; ==================================================
;  Data Set #1 (short list)

	mov	ecx, dword [len1]		; length
	mov	rsi, 0				; starting index of integer list
	mov	rdi, dStrLst1			; address of string

cvtLoop1:
	push	rcx
	push	rdi

	b362int	rdi, tempNum

	mov	eax, dword [tempNum]
	add	dword [sum1], eax

	pop	rdi
	add	rdi, MAX_STR_SIZE

	pop	rcx
	dec	rcx				; check length
	cmp	rcx, 0
	ja	cvtLoop1

	int2b36	sum1, tempString		; convert integer (eax) into undecimal string

	printString	lstSum1			; display header string
	printString	tempString		; print string
	printString	newline

; ==================================================
;  Data Set #2 (long list)

	mov	rcx, [len2]			; length
	mov	rsi, 0				; starting index of integer list
	mov	rdi, dStrLst2			; address of string

cvtLoop2:
	push	rcx
	push	rdi

	b362int	rdi, tempNum

	mov	eax, dword [tempNum]
	add	dword [sum2], eax

	pop	rdi
	add	rdi, MAX_STR_SIZE

	pop	rcx
	dec	rcx				; check length
	cmp	rcx, 0
	ja	cvtLoop2

	int2b36	sum2, tempString		; convert integer (eax) into undecimal string

	printString	lstSum2			; display header string
	printString	tempString		; print string
	printString	newline
	printString	newline


; **********************************************************************************
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall

