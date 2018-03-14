;  CS 218 - Assignment #10
;  Spirograph - Support Functions.
;  Provided Template

; -----
;  Function: getArguments
;	Gets, checks, converts, and returns command line arguments.

;  Function: drawJellyfish()
;	Plots parametric surface equations

; ---------------------------------------------------------

;	MACROS (if any) GO HERE


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program specific constants.

H_MIN		equ	100			; 100(10) = 2S(36)
H_MAX		equ	1200			; 1200(10) = XC(36)

W_MIN		equ	100			; 100(10) = 2S(36)
W_MAX		equ	1200			; 1200(10) = XC(36)

SP_MIN		equ	1			; 1(10) = 1(36)
SP_MAX		equ	1000			; 1000(10) = RS(36)

PS_MIN		equ	1			; 1(10) = 1(10)
PS_MAX		equ	10			; 10(10) = 36(36)

CL_MIN		equ	50			; 50(10) = 1E(36)
CL_MAX		equ	0xffffff		; 16777215(10) = 9ZLDR(36)

; -----
;  Variables for getArguments function.

errUsage	db	"Usage:  ./jelly -h <base36 number> "
		db	"-w <base36 number> -sp <base36 number> ", LF,
		db	"                ",
		db	"-ps <base36 number> -cl <base36 number>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line arguments."
		db	LF, NULL

errHsp		db	"Error, height specifier incorrect."
		db	LF, NULL
errHvalue	db	"Error, height value must be between 2S(36) "
		db	"and XC(36)."
		db	LF, NULL

errWsp		db	"Error, width specifier incorrect."
		db	LF, NULL
errWvalue	db	"Error, width value must be between 2S(36) "
		db	"and XC(36)."
		db	LF, NULL

errSPsp		db	"Error, draw speed specifier incorrect."
		db	LF, NULL
errSPvalue	db	"Error, draw speed value must be between 1(36) "
		db	"and RS(36)."
		db	LF, NULL

errPSsp		db	"Error, point size specifier incorrect."
		db	LF, NULL
errPSvalue	db	"Error, point size value must be between 1(36) "
		db	"and A(36)."
		db	LF, NULL

errCLsp		db	"Error, color specifier incorrect."
		db	LF, NULL
errCLvalue	db	"Error, color value must be between 1E(36) "
		db	"and 9ZLDR(36)."
		db	LF, NULL

; -----
;  Variables for jelly fish plot routine.

tStep		dq	0.1			; controls density of plot
sStep		dq	0.00005			; controls animation speed

pi		dq	3.14159265358979323846
fltNegOne	dq	-1.0
fltZeroPtTwo	dq	0.2
fltZero		dq	0.0
fltOne		dq	1.0
fltOnePtFive	dq	1.5
fltTwo		dq	2.0
fltScale	dq	100000.0
fltTmp		dq	0.0

x		dq	0.0			; current x
y		dq	0.0			; current y
z		dq	0.0			; current z

u		dq	0.0			; u=0.0
v		dq	0.0			; v=0.0
s		dq	0.0			; s=0.0

outterCnt	dq	0			; set based on tStep
innerCnt	dq	0			; set based on tStep

; ------------------------------------------------------------

section  .text

; -----
;  External references for openGL routines.

extern	glutInit, glutInitDisplayMode, glutInitWindowSize, glutInitWindowPosition
extern	glutCreateWindow, glutMainLoop
extern	glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern	glutSwapBuffers, gluPerspective, glutPostRedisplay
extern	glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern	glClear, glLoadIdentity, glMatrixMode, glViewport
extern	glTranslatef, glBegin, glEnd, glVertex3f, glVertex3d,
extern	glColor3f, glRotatef, glRotated
extern	glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern	glPushMatrix, glPopMatrix, glPointSize, glRotatef, glRotated

extern	cosf, sinf, cos, sin

; ******************************************************************
;  Function getArguments()
;	Gets height, width, draw speed, point size, and color values
;	from the command line.

;	Performs error checking, converts ASCII/Undecimal string
;	to integer.  Required command line format (fixed order):
;	  "-h <base36Number> -w <base36Number> -sp <base36Number> 
;		-ps <base36Number> -cl <base36Number>"

; -----
;  Arguments:
;	- ARGC -rdi (value)
;	- ARGV - rsi (address)
;	- height, double-word int, address - rdx
;	- width, double-word int, address - rcx
;	- drawSpeed, double-word int, address - r8
;	- pointSize, double-word int, address - r9
;	- color, double-word int, address - (rbp + 16)



;	YOUR CODE GOES HERE
global getArguments
getArguments:

push r10 ;holds color argument
push r11
push r12
push r13
push r14
push r15

mov r10, 0
mov r10, qword[rbp+16]



cmp rdi, 1
je usageMessage

cmp rdi, 11
jne notEnoughArgs

; checkSpecifier
mov r13, 0
mov r12, 0
mov r13, qword[rsi+8]

mov r12b, byte[r13]
cmp r12b, '-'
jne errHsp

mov r12b, byte[r13+1]
cmp r12b, 'h'
jne errHsp

mov r12b, byte[r13+2]
cmp r12b, NULL
jne errHsp

mov r13, qword[rsi+24]

mov r12b, byte[r13]
cmp r12b, '-'
jne errWsp

mov r12b, byte[r13+1]
cmp r12b, 'w'
jne errWsp

mov r13, qword[rsi+40]

mov r12b, byte[r13]
cmp r12b, '-'
jne errSPsp

mov r12b, byte[r13+1]
cmp r12b, 's'
jne errSPsp

mov r12b, byte[r13+2]
cmp r12b, 'p'
jne errSPsp

mov r13, qword[rsi+56]

mov r12b, byte[r13]
cmp r12b, '-'
jne errPSsp

mov r12b, byte[r13+1]
cmp r12b, 'p'
jne errPSsp

mov r12b, byte[r13+2]
cmp r12b, 's'
jne errPSsp

mov r13, qword[rsi+72]

mov r12b, byte[r13]
cmp r12b, '-'
jne errCLsp

mov r12b, byte[r13+1]
cmp r12b, 'c'
jne errCLsp

mov r12b, byte[r13+1]
cmp r12b, 'l'
jne errCLsp


; values

mov r12, 0
mov r13, 0
mov r11, 0
mov r15, 16

mov r12, rdi ;argc
mov r13, rsi ; argv
mov r11, rdx ; height


mov rdi, 0
mov rsi, 0
mov rdx, 0

loopInt:

mov rdi, [r13 + r15]
mov r14, 0
mov r14b, byte[rdi + rsi]
cmp r14b, NULL
je doneHcount
counterH:

mov r14b, byte[rdi+rsi]
inc rsi
cmp r14b, NULL
jne counterH

doneHcount:
inc rsi

mov rdx, 0
mov rax, 0

call convert36

cmp r15, 16
je HvalueCmp

cmp r15, 32
je WvalueCmp

cmp r15, 48
je SPValueCmp

cmp r15, 56
je PSValueCmp

cmp r15, 80
je CLvalueCmp

HvalueCmp:
cmp rax, FALSE
je errHvalue
jmp nextCompare
WvalueCmp:
cmp rax, FALSE
je errWvalue
jmp nextCompare
SPValueCmp:
cmp rax, FALSE
je errSPvalue
jmp nextCompare
PSValueCmp:
cmp rax, FALSE
je errPSvalue
jmp nextCompare
CLvalueCmp:
cmp rax, FALSE
je errCLvalue
jmp nextCompare

nextCompare:

H_MIN_MAX:

mov r14, 0
mov r14d, dword[rdx]
cmp r14d, dword[H_MIN]
jl errHvalue

cmp r14d, dword[H_MAX]
jg errHvalue
mov rax, 0
mov rax, dword[rdx]
mov dword[r11], rax
jmp finalCompare

W_MIN_MAX:
mov r14, 0
mov r14d, dword[rdx]
cmp r14d, dword[W_MIN]
jl errWvalue

cmp r14d, dword[W_MAX]
jg errWvalue
mov rax, 0
mov rax, dword[rdx]
mov dword[rcx], rax
jmp finalCompare

SP_MIN_MAX:
mov r14, 0
mov r14d, dword[rdx]
cmp r14d, dword[SP_MIN]
jl errSPvalue

cmp r14d, dword[SP_MAX]
jg errSPvalue
mov rax, 0
mov rax, dword[rdx]
mov dword[r8], rax
jmp finalCompare

PS_MIN_MAX:
mov r14, 0
mov r14d, dword[rdx]
cmp r14d, dword[PS_MIN]
jl errPSvalue

cmp r14d, dword[PS_MAX]
jg errPSvalue
mov rax, 0
mov rax, dword[rdx]
mov dword[r9], rax
jmp finalCompare

CL_MIN_MAX:
mov r14, 0
mov r14d, dword[rdx]
cmp r14d, dword[CL_MIN]
jl errCLvalue

cmp r14d, dword[CL_MAX]
jg errCLvalue
mov rax, 0
mov rax, dword[rdx]
mov dword[r10], rax
jmp finalCompare

finalCompare:

add r15, 16
cmp r15, 96
jne loopInt

mov rdi, 0
mov rsi, 0
mov rdx, 0

mov rdi, r12
mov rsi, r13
mov rdx, r11

jmp doneFunction



usageMessage:
lea rdi, [errUsage]
call printString
mov rax, FALSE
jmp doneFunction

errorBadCL:
lea rdi, [errBadCL]
call printString
mov rax, FALSE
jmp doneFunction

errorHeightVal:
lea rdi, [errHvalue]
call printString
mov rax, FALSE
jmp doneFunction

errorHeightSp:
lea rdi, [errHsp]
mov rax, FALSE
jmp doneFunction

errorWidthsp:
lea rdi, [errWsp]
mov rax, FALSE
jmp doneFunction

errorWidthVal:
lea rdi, [errWvalue]
mov rax, FALSE
jmp doneFunction

errorDrawsp:
lea rdi, [errSPsp]
mov rax, FALSE
jmp doneFunction

errorDrawVal:
lea rdi, [errSPvalue]
mov rax, FALSE
jmp doneFunction

errorPointSp:
lea rdi, [errPssp]
mov rax, FALSE
jmp doneFunction

errorPointVal:
lea rdi, [errPSvalue]
mov rax, FALSE
jmp doneFunction

errorColorSP:
lea rdi, [errCLsp]
mov rax, FALSE
jmp doneFunction

errorColorVal:
lea rdi, [errCLvalue]
mov rax, FALSE
jmp doneFunction



doneFunction:

pop r14
pop r15
pop r13
pop r12
pop r11
pop r10
ret



; ******************************************************************
;  Boolean function to convert base-36 string to integer.
;  convert36 
;  (strAddress) -rdi
;  (length) - rsi
;  returnINT - rdx
;  returns in rax


;	YOUR CODE GOES HERE
global convert36
convert36:


push rbx
push rcx
push r12
push r11
push r13
push r14


mov r14, rdx
mov r13, 0
mov rbx, rdi ;store strAddress
mov rcx, rsi ; store string length
dec rcx

cvt36toInt:
mov rax, 0
mov rax, 36
mov r12, rcx ;exp counter

exponentSet:
mul rax

dec r12
cmp r12, 0
jne exponentSet

mov r11, 0
mov r11b, byte[rdi + rcx]

cmp r11b, "0"
jl notValid

cmp r11b, "9"
jg overNine
jmp doConversionInt

overNine:
cmp r11b, "A"
jl notValid

cmp r11b, "Z"
jg overUpper
jmp doConversionUpper

overUpper:
cmp r11b, "a"
jl notValid

cmp r11b, "z"
jg notValid 
jmp doConversionLower

doConversionInt:
sub r11b, "0"
mul r11b
jmp nextThing

doConversionUpper:
sub r11b, "A"
add r11b, 10
mul r11b
jmp nextThing

doConversionLower:
sub r11b, "a"
add r11b, 10
mul r11b
jmp nextThing

nextThing:
add r13, r11
dec rcx
cmp rcx, 0
jg convertLoop

mov rdx, 0
mov rdx, r14
mov dword[rdx], eax
mov rax, 0
mov rax, TRUE
jmp doneConvert

notValid:

mov rax, FALSE

doneConvert:
pop r14
pop r13
pop r11
pop r12
pop rcx
pop rbx

ret




; ******************************************************************
;  Parametric Equation Plotting Function.

; -----
;  Basic flow:
;	set openGL drawing initializations
;	set draw color (i.e., glColor3ub)
;	set point size (i.e., glpointSize)
;	convert integer values to float for calculations
;	calculate number of iterations (for loops)
;	for (double u=0.0; u<(2.0*pi); u+=tStep) {
;		for (double v=-1.0; v<1.0; v+=tStep) {
;			x = sqrt((2.0 * s - 1.0) * v + 0.2) * cos(u);
;			y = sqrt((2.0 * s - 1.0) * v + 0.2) * sin(u);
;			z = (1.0 - (2.0 * s - 1.0)^2) * v;
;		        glVertex3d(x, y, z);
;		}
;	}
;	close openGL plotting (i.e., glEnd and glFlush)
;	set for next draw (glutPostRedisplay)

;  The outter loop is from 0.0 to 2*pi by tStep, can calculate
;  the number if iterations via:  iterations = 2*pi / tStep
;  The inner loop is from -1.0 to 1.0 by tStep, can calculate
;  the number if iterations via:  iterations = 2.0 / tStep
;  This eliminates needing a float compare (a hassle).

; -----
;  Global variables accessed
;	There are defined and set in the main, accessed herein by
;	name as per the below declarations.

common	viewAngle	1:8		; viewAngle, dword, double value
common	tipAngle	1:8		; tipAngle, dword, double value
common	drawSpeed	1:4		; draw speed (integer)
common	pointSize	1:4		; point size (integer)
common	color		1:4		; color value (integer)

global drawJellyfish
drawJellyfish:

; -----
;  Prologue



; -----
;  Prepare for drawing

	; glClear(GL_COLOR_BUFFER_BIT);
	mov		rdi, GL_COLOR_BUFFER_BIT
	call		glClear

	; glPushMatrix();
	call		glPushMatrix

	; glRotatef(viewAngle, 1.0, 0.0, 0.0);
	movsd		xmm0, qword [viewAngle]
	movsd		xmm1, qword [fltOne]
	movsd		xmm2, qword [fltZero]
	movsd		xmm3, qword [fltZero]
	call		glRotated

	; glRotatef(tipAngle, 0.0, 1.0, 0.0);
	movsd		xmm0, qword [tipAngle]
	movsd		xmm1, qword [fltZero]
	movsd		xmm2, qword [fltOne]
	movsd		xmm3, qword [fltZero]
	call		glRotated

	; glPointSize(pointSize);
	cvtsi2ss	xmm0, dword [pointSize]
	call		glPointSize

	; glBegin(GL_POINTS);
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set draw color(r,g,b)

mov rdx, 100
mov rsi, 200
mov rdx, 10

call glColor3ub


; -----
;  Set draw speed



; -----
;  Calculate iterations for inner and outter loops



; -----
;	for (double u=0.0; u<(2.0*pi); u+=tStep) {
;		for (double v=-1.0; v<1.0; v+=tStep) {
;			x = sqrt((2.0 * s - 1.0) * v + 0.2) * cos(u);
;			y = sqrt((2.0 * s - 1.0) * v + 0.2) * sin(u);
;			z = (1.0 - (2.0 * s - 1.0)^2) * v;
;		        glVertex3d(x, y, z);
;		}
;	}


; -----
;  Plotting done.

	call	glEnd
	call	glPopMatrix
	call	glFlush

; -----
;  Update s and check
;	s += sStep;

; -----
;  Check s range
;	if (s > 1.0)
;		s = 0.0;

	movsd	xmm0, qword [s]
	movsd	xmm1, qword [fltOne]
	ucomisd	xmm0, xmm1			; if (s > 1.0)
	jbe	setSDone
	movsd	xmm0, qword [fltZero]
	movsd	qword [s], xmm0
setSDone:

; -----
;  Set up for next call

	call	glutPostRedisplay

; -----
;  Done, exit.
;	epilogue


	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	- address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters in string.

	mov	r10, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [r10], NULL
	je	strCountDone
	inc	r10
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	ret

; ******************************************************************

