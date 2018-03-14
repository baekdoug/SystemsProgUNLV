; **********************************************************************************
;  Macro, "int2b36", to convert a signed base-10 integer into an
;  ASCII string representing the base-36 value.  The macro stores
;  the result into an ASCII string (byte-size, right justified,
;  blank filled, NULL terminated).  Each integer is a doubleword value.
;  Assumes valid/correct data.  As such, no error checking is performed.

; -----
;  Arguments
;	%1 -> integer number
;	%2 -> string address

%macro	int2b36	2


;	YOUR CODE GOES HERE

push rax
push rbx
push rcx
push rdx
push r9
push r10
push r11
push r12


mov rax, 0
mov rbx, 0
mov rcx, 0
mov rdx, 0
mov r9, 0
mov r9d, 36
mov r10, 0 ;tempNum
mov r11, 0 ;tempString in stack
mov r12, 0 ;String
mov eax, dword[%1]
lea r12, [%2]


%%convert2String:
div r9d 
mov r10d, edx
mov rdx, 0
mov bl, r10b
cmp bl, 10
jge %%isAlphaInt

add bl, "0"
mov r11b, bl
push r11
inc ecx

jmp %%doneInt
%%isAlphaInt:

sub bl, 10
add bl, "A"
mov r11b, bl
push r11
inc ecx


%%doneInt:
cmp eax, 0
jne %%convert2String
mov r9, 0
%%moveToString:
mov rax, 0
pop r11
mov al, r11b
mov byte[r12 + r9], al


inc r9
dec ecx
cmp ecx, 0
jge %%moveToString
dec r9
 mov byte[r12 + r9], NULL


pop rax
pop rbx
pop rcx
pop rdx
pop r9
pop r10
pop r11
pop r12



%endmacro



section .data

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


MAX_STR_SIZE	equ	10			; note, includes the NULL
NUMS_PER_LINE	equ	5

uStr1		db	"    74", NULL
iNum1		dd	12345678

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


section	.bss

num1String	resb	MAX_STR_SIZE
tempString	resb	MAX_STR_SIZE
tempNum		resd	1



section	.text
global	_start
_start:




int2b36 iNum1, num1String

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall