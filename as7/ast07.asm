; CS 218
; Assignment #7

; Sort a list of number using the shell sort algorithm.
; Also finds the minimum, median, maximum, and average of the list.

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


; --------------------------------------------------------------
;  Simple macro to display a string.
;	Call:	printString  <stringAddress>

;	Arguments:
;		%1 -> <string>, string address

;  Count characters (excluding NULL).
;  Display string starting at address <string>

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

; ---------------------------------------------

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

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
NULL		equ	0
ESC		equ	27

; -----
;  Provided data

lst	dd	1113, 1232, 2146, 1376, 5120, 2356,  164, 4565, 155, 3157
	dd	 759, 326,  171,  147, 5628, 7527, 7569,  177, 6785, 3514
	dd	1001,  128, 1133, 1105,  327,  101,  115, 1108,    1,  115
	dd	1227, 1226, 5129,  117,  107,  105,  109,  999,  150,  414
	dd	 107, 6103,  245, 6440, 1465, 2311,  254, 4528, 1913, 6722
	dd	1149,  126, 5671, 4647,  628,  327, 2390,  177, 8275,  614
	dd	3121,  415,  615,  122, 7217,    1,  410, 1129,  812, 2134
	dd	 221, 2234,  151,  432,  114, 1629,  114,  522, 2413,  131
	dd	5639,  126, 1162,  441,  127,  877,  199,  679, 1101, 3414
	dd	2101,  133, 1133, 2450,  532, 8619,  115, 1618, 9999,  115
	dd	 219, 3116,  612,  217,  127, 6787, 4569,  679,  675, 4314
	dd	1104,  825, 1184, 2143, 1176,  134, 4626,  100, 4566,  346
	dd	1214, 6786,  617,  183,  512, 7881, 8320, 3467,  559, 1190
	dd	 103,  112,    1, 2186,  191,   86,  134, 1125, 5675,  476
	dd	 100,    1, 1146,  100,  101,    1, 5616, 5662, 6328, 2342
	dd	2137, 2113,  647,  114,  115, 6571, 7624,  128,  113, 3112
	dd	 724,  316, 1217, 2183, 4352,  121,  320, 4540, 5679,  190
	dd	9125,  116, 1122,  117,  127, 5677,  101, 3727, 6512, 3184
	dd	1897, 6374,  190, 1667, 1224, 7123,  116,  126, 6784, 2329
	dd	 104,  124, 1112,  187,  176, 7534, 2126, 6112,  156,  103
	dd	1153,  172, 1146, 2176,  170,  156,  164,  165,  155, 5156
	dd	 894, 6325,  100,  143,  276, 5634, 7526,  413, 7686,  563
	dd	 511,  383, 1133, 2150,  825, 5721,  615, 4568, 7813, 1231
	dd	 999,  146,  162,  147,  157,  167,  169,  177,  175,  144
	dd	5527, 1344, 1130, 2172,  224, 7525,  100,    1,  100, 1134   
	dd	 181,  155, 1145,  132,  167,  185,  150,  149,  182,  434
	dd	 581,  625, 6315,    1,  617,  855, 6737,  129, 4512,    1
	dd	 177,  164,  160, 1172,  184,  175,  166, 6762,  158, 4572
	dd	6561,  283, 1133, 1150,  135, 5631, 8185,  178, 1197,  185
	dd	 649, 6366, 1162,  167,  167,  177,  169, 1177,  175, 1169

len	dd	300

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0

; -----
;  Misc. data definitions (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0
dSix		dd	6
dTwo		dd	2
dThree		dd	3


; -----
;  Provided string definitions.

MAX_STR_SIZE	equ	12

newLine		db	LF, NULL

hdr		db	LF, "---------------------------"
		db	"---------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #7", ESC, "[0m"
		db	LF, "Shell Sort", LF, LF, NULL

hdrMin		db	"Minimum:  ", NULL
hdrMax		db	"Maximum:  ", NULL
hdrMed		db	"Median:   ", NULL
hdrSum		db	"Sum:      ", NULL
hdrAve		db	"Average:  ", NULL

; ---------------------------------------------

section .bss

tmpString	resb	MAX_STR_SIZE

; ---------------------------------------------

section	.text
global	_start
_start:

; ******************************
;  Shell Sort.

mov rax, 0
mov eax, 1
mov rbx, 0
mov r9, 0
;mov r9, lst
mov r10, 0

;       while ( (h*3+1) < a.length){
;	    h = 3 * h + 1;
;	} 
whileLp:
mov r10d, eax
mul dword[dThree]
add eax, 1
cmp eax, dword[len]
jb whileLp
mov eax, r10d


;       while( h > 0 ) {
whileLp2:

;           for (ebx = eax-1; ebx < len; ebx++) {
	mov ebx, eax
	dec ebx
	forLp:

;               tmp = lst[ebx];
	mov r10, 0
	mov r10d, dword[lst + (rbx*4)]
	mov dword[tmp], r10d
;               r11 = ebx;
	mov r11, 0
	mov r11d, ebx
;               for( r11 = ebx; (r11 >= eax) && (lst[r11-eax] > tmp); r11 -= eax) {
		mov r11d, ebx
		forInner:

;                   lst[r11] = lst[r11-eax];
;               }
		mov rcx, 0
		mov r13d, 0
		mov r13d, r11d
		sub r13d, eax
        cmp r11d, eax
        jb isFirstPass
		mov ecx, dword[lst + (r13d * 4)]
		mov dword[lst + (r11d * 4)], ecx
		


		sub r11d, eax
		cmp r11d, eax
		jae firstPass
		jmp forInner
		firstPass:
		mov r12, 0
		mov r12d, dword[tmp]
		cmp dword[tmp + (r13 * 4)], r12d 
		ja secondPass
		jmp forInner
		secondPass:
        isFirstPass:
;               a[r11] = tmp;
	mov rcx, 0
	mov ecx, dword[tmp]
	mov dword[lst + (r11d * 4)], ecx
;           }
	inc ebx
	cmp ebx, dword[len]
	jb forLp


;           eax = eax / 3;
div dword[dThree]
;       }
cmp eax, 0
ja whileLp2	


;  Find sum and compute the average.
mov rax, 0
mov rcx, 0
mov ecx, dword[len]

sumLp:
mov eax, dword[lst + (ecx*4)]
add dword[sum], eax
loop sumLp

div dword[len]
mov dword[avg], eax









;  Get/save min and max.
mov rax, 0
mov eax, dword[lst]
mov dword[min], eax

mov rax, 0
mov rbx, 0
mov ebx, dword[len]
dec rbx
mov eax, dword[lst + (ebx * 4)]
mov dword[max], eax

;  Find median.










; ******************************
;  Display results to screen in hex.

	printString	hdr

	printString	hdrMin
	int2b36		min, tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMax
	int2b36		max, tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMed
	int2b36		med, tmpString
	printString	tmpString
	printString	newLine

	printString	hdrSum
	int2b36		sum, tmpString
	printString	tmpString
	printString	newLine

	printString	hdrAve
	int2b36		avg, tmpString
	printString	tmpString
	printString	newLine
	printString	newLine

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, EXIT_SUCCESS
	syscall

