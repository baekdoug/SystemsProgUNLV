;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write four assembly language functions.

;  The function, shellSort(), sorts the numbers into ascending
;  order (small to large).  Uses the shell sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  The listMedian function mist be called.

;  The function, listMedian(), to find the median of a list of
;  sorted numbers.

;  The function, corrCoefficient(), computes the correlation coefficient
;  for the two data sets.

;  Summation and division performed as integer values.


; ********************************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Variables for shellSort() function (if any).



; -----
;  Variables for basicStats() function (if any).

even2   dd     2
div3 dd 3


; -----
;  Variables for corrCoefficient() function (if any).



; ********************************************************************************

section	.text

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


;	YOUR CODE GOES HERE
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

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  Note, the list is already sorted.

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


;	YOUR CODE GOES HERE
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

; -----
;  HLL Call:
;	ans = listMedian(lst, len)

;  Arguments Passed:
;	- list, address -rdi
;	- length, value -rsi

;  Returns:
;	median (in eax)


;	YOUR CODE GOES HERE
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


;	YOUR CODE GOES HERE
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

