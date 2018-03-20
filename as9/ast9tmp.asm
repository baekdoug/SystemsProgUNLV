;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write assembly language functions.

;  The void function, shellSort(), sorts the numbers into ascending
;  order (small to large).  Uses the insertion sort algorithm from
;  assignment #8 (modified to sort in ascending order).

;  The void function, basicStats(), finds the minimum, median, and
;  maximum, sum, and average for a list of numbers.
;  The median is determined after the list is sorted.

;  The value returning integer function, listMedian(), to find and
;  return the integer median of a sorted list.

;  The value returning double function, corrCoefficient(), computes
;  the correlation coefficient for the two data sets.
;  Final result is real in xmm0.


; ********************************************************************************

section	.data

; -----
;  Define standard constants.

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
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Define program specific constants.

SUCCESS 	equ	0
BADNUMBER	equ	1
INPUTOVERFLOW	equ	2
OUTOFRANGE	equ	3
ENDOFINPUT	equ	4

MIN		equ	1
MAX		equ	1000000
BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...


; ********************************************************************************

section	.text

; --------------------------------------------------------
;  Read an ASCII base-36 number from the user

;  Return codes:
;	SUCCESS		Successful conversion
;	BADNUMBER	Invalid input entered
;	INPUTOVERFLOW	User entry character count exceeds maximum length
;	OUTOFRANGE	Valid, but out of required range
;	ENDOFINPUT	End of the input

; -----
;  HLL Call:
;	status = readB36Num(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr -- rdi

;  Returns:
;	number read (via reference)
;	status code (as above)


global: readB36Num
readB36Num:

push rbx
push r9
push rsi
push r10
push rdx
push rcx
push r11

mov r9, rdi 
mov rsi, 0
mov rcx, 0
mov r10, 0
mov rbx, 0 ;temp character
mov rdx, 0
mov r11, 0 ; counter

loopRead:

    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, rbx
    mov rdx, 1
    syscall
    

    mov r10, 0
    mov r10, [rbx]
    cmp r10, " "
    je loopRead

    notBlank:

    cmp r11, 0
    je checkBlank

    cmp r10, LF
    je isLF

    inc r11

    cmp r11, BUFFSIZE
    jg overFlow

    push push r10 ;stores all input data


jmp loopRead

checkBlank:
cmp r10, LF
je isBlank
jmp notBlank


isLF:

mov rax, 0
mov rax, 36

calcLoop:

pop r10

mov rbx, 0
mov rbx, r11
innerLP:

mul rax

cmp rbx, 0
jne innerLP

mul r10

add rcx, r10; total calc

dec r11
cmp r11, 0
jg calcLoop


cmp rcx, MAX 
jg outOfRange 


mov rax, SUCCESS
jmp finished

outOfRange:
mov rax, OUTOFRANGE
jmp finished

overFlow:
mov rax, INPUTOVERFLOW
jmp finished

isBlank:
mov rax, ENDOFINPUT
jmp finished


finished:





pop r11
pop rdx
pop rcx
pop r10
pop rsi
pop r9
pop rbx
ret



; ********************************************************************
;  Shell sort function.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)


global shellSort
shellSort:

push rbx
push r10 ;h
push r11 ;i
push r12 ;tmp
push r13 ;j
push r14 ;j-h
push r15 ;j-h tmp

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
ret




; ********************************************************************
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, must call the lesitMedian function.

; -----
;  HLL Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)



global basicStats
basicStats:


push r10 ;will store and return average
push r11
push r12
push r13
push rax
push rbp
push r14

mov rbp, rsp

mov r10, 0
mov r11, 0
mov r12, 0
mov rax, 0

mov r10, qword[rbp+16]

mov r11d, dword[rdi]
mov dword[rdx], r11d ; returns min

mov r11d, dword[rdi + (rsi * 4)]
mov dword[r8], r11d ; returns max
mov r13, 0
sumLp:
add r13d, dword[rdi + (4 * r12)]

inc r12
cmp r12d, esi
jl sumLp
mov dword[r9], r13d ; returns sum

mov eax, r13d
push rdx
mov rdx, 0
div esi
mov rdx, 0
pop rdx
mov dword[r10], eax ;returns ave

mov rax, 0

call listMedian

mov dword[rcx], eax


pop r14
pop rbp
pop rax
pop r13
pop r12
pop r11
pop r10
ret



; ********************************************************************
;  Function to calculate the estimated median of an unsorted list.

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

; -----
;  HLL Call:
;	ans = listMedian(lst, len)

;  Arguments Passed:
;	- list, address
;	- length, value

;  Returns:
;	median (in eax)



global listMedian
listMedian:

push r9
push r10
push rdx

mov r9, 0
mov r10, 0
mov rax, 0
mov rdx, 0
mov eax, esi
div dword[even2] 
mov r10d, eax
mov eax, 0
cmp edx, 0
je isEven

;odd
dec r10d

mov eax, dword[rdi + (r10 * 4 )]
jmp isEnd

isEven:

dec r10d
add r9d, dword[rdi + (r10 * 4)]
inc r10d
add r9d, dword[rdi + (r10 * 4)]
mov eax, r9d
div dword[even2]

isEnd:



pop rdx
pop r9
pop r10
ret


; ********************************************************************
;  Function to calculate the correlation coefficient
;  between two lists (of equal size).

; -----
;  HLL Call:
;	r = corrCoefficient(xList, yList, len)

;  Arguments Passed:
;	1) xList, addr - rdi
;	2) yList, addr - rsi
;	3) length, value - rdx

;  Returns:
;	r value (in eax)



global corrCoefficient
corrCoefficient:
push r10 ;stores top mults
push r11 ; stores bottom total
push r12 ; store temp numbers
push r14 ; stores other temp
push r13 ; counter

mov rax, 0
mov r13, 0
topLP:
mov eax, 0
mov r14d, 0
mov eax, dword[rdi + (r13 * 4)]
mov r14d, dword[rsi + (r13 * 4)]
mul r14d
add r10d, eax

inc r13
cmp r13d, edx
jl topLP

mov r13, 0
mov rax, 0
mov r11, 0
mov r14, 0
mov r12, 0
botLP:
mov rax, 0
mov eax, dword[rdi + (r13 * 4)]
mul eax
add r12d, eax

mov rax, 0
mov eax, dword[rsi + (r13 * 4)]
mul eax
add r14d, eax




inc r13
cmp r13d, edx
jl botLP

mov rax, 0
mov eax, r12d
mul r14d
mov r11d, eax
mov rax, 0
;top r10d bot r11d

cvtsi2sd xmm0, r10
cvtsi2sd xmm1, r11
sqrtsd xmm1, xmm1
divsd xmm0, xmm1




pop r14
pop r12
pop r13
pop r10
pop r11
ret



; ********************************************************************************

