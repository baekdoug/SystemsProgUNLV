section	.data

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

LF		equ	10
NULL		equ	0
ESC		equ	27

; -----
;  Data Sets for Assignment #8.

xList1		dd	 13, 11, 4, 6, 5 
             dd  7, 8, 10, 1, 3 
            
yList1		dd	1230, 1233, 1323, 1241, 1360
		dd	1290, 1118, 1250, 1475, 1423
		dd	1210, 1337, 1226
len1		dd	10
xMin1		dd	0
xMed1		dd	0
xMax1		dd	0
xSum1		dd	0
xAve1		dd	0
yMin1		dd	0
yMed1		dd	0
yMax1		dd	0
ySum1		dd	0
yAve1		dd	0
r1		dq	0


xList2		dd	 127,  135,  117,  115,  261
		dd	 210,  220,  222,  224,  226
		dd	 129,  113,  155,  235,  237
		dd	 219,  241,  143,  245,  149
		dd	 153,  119,  223,  117,  259
		dd	 116,  115,  251,  267,  169
		dd	 228,  230,  132,  133,  221
		dd	 138,  240,  142,  244,  246
		dd	 221,  125,  251,  213,  119
		dd	 157,  299,  153,  265,  279
yList2		dd	 127,  155,  217,  115,  161
		dd	 283,  214,  121,  228,  212
		dd	 126,  117,  227,  127,  284
		dd	 174,  212,  125,  126,  229
		dd	 288,  215,  111,  118,  215
		dd	 126,  117,  215,  210,  114
		dd	 124,  243,  134,  212,  113
		dd	 172,  276,  256,  265,  156
		dd	 253,  140,  291,  268,  162
		dd	 246,  247,  167,  177,  144
len2		dd	50
xMin2		dd	0
xMed2		dd	0
xMax2		dd	0
xSum2		dd	0
xAve2		dd	0
yMin2		dd	0
yMed2		dd	0
yMax2		dd	0
ySum2		dd	0
yAve2		dd	0
r2		dq	0


xList3		dd	  44,   34,   13,   21,   16
		dd	  41,   33,   24,   13,   23
		dd	  18,   43,   12,   10,   10
		dd	  24,   43,   24,   12,   23
		dd	  53,   40,   11,   18,   12
		dd	  47,   27,    9,   17,   19
		dd	  83,   50,    1,   28,   15
		dd	  83,   14,   11,   18,   12
		dd	  26,   17,   17,   17,   14
		dd	  74,   12,   15,   16,   29
		dd	  18,    5,   11,   18,   15
		dd	  26,   17,   15,    3,   14
		dd	  24,   13,   14,   12,   13
		dd	  72,   26,   16,   15,   16
		dd	  53,   10,   11,   18,   12
		dd	  46,   17,   17,   17,   14
		dd	  55,   12,   15,   19,   14
		dd	  64,    2,   15,   12,   12
		dd	  83,   15,   11,   18,   11
		dd	  66,   17,   17,   17,   14
yList3		dd	 310,  220,  232,  324,  326
		dd	 319,  313,  235,  235,  337
		dd	 339,  341,  243,  245,  249
		dd	 253,  219,  213,  210,  229
		dd	 216,  215,  351,  367,  219
		dd	 328,  330,  332,  233,  321
		dd	 238,  340,  242,  244,  346
		dd	 321,  325,  351,  213,  219
		dd	 257,  339,  253,  365,  379
		dd	 227,  355,  317,  215,  211
		dd	 383,  314,  311,  328,  312
		dd	 226,  217,  227,  227,  314
		dd	 318,  315,  311,  218,  315
		dd	 226,  217,  215,  211,  314
		dd	 324,  343,  334,  312,  213
		dd	 322,  276,  356,  265,  356
		dd	 253,  240,  291,  368,  322
		dd	 246,  247,  367,  377,  244
		dd	 255,  332,  385,  249,  314
		dd	 364,  372,  275,  262,  372
len3		dd	100
xMin3		dd	0
xMed3		dd	0
xMax3		dd	0
xSum3		dd	0
xAve3		dd	0
yMin3		dd	0
yMed3		dd	0
yMax3		dd	0
ySum3		dd	0
yAve3		dd	0
r3		dq	0
div3    dd  3

numtest dd 0

; --------------------------------------------------------


section	.text
global	_start
_start:

push rbx
push r10 ;h
push r11 ;i
push r12 ;tmp
push r13 ;j
push r14 ;j-h
push r15 ;j-h tmp

mov rdi, xList1
mov rsi, 0
mov esi, dword[len1]

mov rbx, 0
mov r12, 0
mov r13, 0
mov r10, 0
mov r14, 0
mov r11, 0
mov rax, 0

;h=1
mov r10d, 1


;precondition check for while
mov eax, r10d
mul dword[div3]
inc eax
cmp eax, esi
jge skipFirstWhile
mov rax, 0
mov eax, r10d
;while (h*3+1 < len)
firstWhile:
mov r14d, eax
mul dword[div3]
inc eax
mov ebx, eax
dec ebx


cmp ebx, esi
jl firstWhile

skipFirstWhile:
mov r10d, r14d
mov rax, 0

cmp r10d, 0
jl skipSecondWhile
;while( h > 0 ){
secondWhile:
    mov r11d, r10d
    dec r11d
    cmp r11d, esi
    jge skipInner
    ;for(i = h-1; i< length ; i++){
        forInner:
        ;tmp = lst[i]
        mov r12d, dword[rdi + (r11 * 4)]
    
        ;j=i
        mov r13d, r11d
        mov r15, 0
        mov r15d, r13d
        sub r15d, r10d
        cmp r13d, r10d
        jl skipThis
        cmp dword[rdi + (r15 * 4)], r12d
        jle skipThis2
    
            ;for(j = i; (j >= h) && (lst[j-h] > tmp); j = j-h){
                ; lst[j] = lst[j-h]
                forInner2:
                mov r15, 0
                mov r15d, r13d
                sub r15d, r10d
                mov eax, dword[rdi + (r15 * 4)]
                mov dword[rdi + (r13 * 4)], eax
                mov r13d, r15d

                cmp r13d, r10d
                jl skipThis
                sub r15d, r10d
                cmp dword[rdi + (r15 * 4)], r12d
                jg forInner2
            ; }


        skipThis:
        skipThis2:
        ;lst[j] = tmp;
        
        mov dword[rdi + (r13 * 4)], r12d
        inc r11d
        cmp r11d, esi
        jl forInner
    ;}
    skipInner:
    ;h = h / 3
    mov rax, 0
    mov eax, r10d
    div dword[div3]
    mov r10d, eax
    cmp r10d, 0
    jg secondWhile
;}
skipSecondWhile:

pop rbx
pop r11
pop r10
pop r12
pop r13
pop r14
pop r15


; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, EXIT_SUCCESS
	syscall

