;Doug Baek
;Sec 01
;Assignment 5


section	.data
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate


;  Provided Data

sideLens	dd	 1145,  1135,  1123,  1123,  1123
		    dd	 1254,  1454,  1152,  1164,  1542
		    dd	 1353,  1457,  1182,  1142,  1354
		    dd	 1364,  1134,  1154,  1344,  1142
		    dd	 1173,  1543,  1151,  1352,  1434
		    dd	 1355,  1037,  1123,  1024,  1453
		    dd	 1134,  2134,  1156,  1134,  1142
		    dd	 1267,  1104,  1134,  1246,  1123
		    dd	 1134,  1161,  1176,  1157,  1142
		    dd	 1153,  1193,  1184,  1142,  2034

apothemLens	dw	  133,   114,   173,   131,   115
		    dw	  164,   173,   174,   123,   156
		    dw	  144,   152,   131,   142,   156
		    dw	  115,   124,   136,   175,   146
		    dw	  113,   123,   153,   167,   135
		    dw	  114,   129,   164,   167,   134
		    dw	  116,   113,   164,   153,   165
		    dw	  126,   112,   157,   167,   134
		    dw	  117,   114,   117,   125,   153
		    dw	  123,   173,   115,   106,   113

length		dd	50

areaMin		dd	0
areaMid		dd	0
areaMax		dd	0
areaSum		dd	0
areaAve		dd	0

perimMin	dd	0
perimMid	dd	0
perimMax	dd	0
perimSum	dd	0
perimAve	dd	0


; Uninitialized data


section .bss
hexAreas    resd    50
hexPerims   resd    50



;.............................


;****************************************************

section	.text
global _start
_start:



; hexPerim[i] = 6 * sideLens[i]




mov rax, 0
mov ecx, 0
mov ecx, dword[length]
dec ecx
mov rbx, 0
mov ebx, sideLens 
hexPerimLP:
mov eax, dword[ebx + (ecx * 4)]
mov r11d, 0
mov r11d, 6
mul r11d
mov dword[hexPerims + (ecx * 4)], eax 
add dword[perimSum], eax


dec ecx
cmp ecx, 0
jge hexPerimLP

mov r11d, 0
; hexArea[i] = (hexPerims[i] * apothemLen[i]) / 2




mov rax, 0
mov ecx, 0
mov rbx, 0
mov ebx, hexPerims 
mov r9d, 0
hexAreasLP:
mov eax, dword[ebx + (ecx * 4)]
mov r10, 0
mov r10d, apothemLens
movzx r9d, word[r10d + (ecx * 2)]
mul r9d 
mov r11, 0
mov r11d, 2
div r11d
mov dword[hexAreas + (ecx * 4)], eax 
add dword[areaSum], eax


inc ecx
cmp ecx, dword[length]
jl hexAreasLP

hexAreaStatLp:
mov rax, 0
mov rbx, 0
mov ebx, hexAreas
mov eax, dword[ebx]
mov dword[areaMin], eax
mov dword[areaMax], eax

mov ecx, 0
mov ecx, dword[length]
dec ecx

hexAreaMinMaxLp:

mov eax, dword[ebx + (ecx * 4)]
cmp dword[areaMin], eax
jl notAreaMin
mov dword[areaMin], eax

notAreaMin:
cmp dword[areaMax], eax
jg notAreaMax
mov dword[areaMax], eax

notAreaMax:
dec ecx
cmp ecx, 0
jg hexAreaMinMaxLp

mov r10, 0
mov r11, 0

hexPerimStatLp:
mov rax, 0
mov rbx, 0
mov ebx, hexPerims
mov eax, dword[ebx]
mov dword[perimMin], eax
mov dword[perimMax], eax

mov ecx, 0
mov ecx, dword[length]
dec ecx

hexPerimMinMaxLp:

mov eax, dword[ebx + (ecx * 4)]
cmp dword[perimMin], eax
jl notPerimMin
mov dword[perimMin], eax

notPerimMin:
cmp dword[perimMax], eax
jg notperimMax
mov dword[perimMax], eax

notperimMax:
dec ecx
cmp ecx, 0
jg hexPerimMinMaxLp

;-----MID STUFF
mov rax, 0
mov rdx, 0
mov rcx, 0

mov eax, dword[length]
mov ecx, 2
div ecx

cmp edx, 0
jne isOdd

mov ebx, hexAreas
mov ecx, 0 
dec eax
mov ecx, dword[ebx + (eax * 4)]
inc eax
add ecx, dword[ebx + (eax * 4)]
mov rax, 0
mov rdx, 0

mov eax, ecx
mov ecx, 2
div ecx
mov dword[areaMid], eax


jmp finishThis
isOdd:

mov rax, 0
mov eax, dword[length]
mov rcx, 0
mov ecx, 2
div ecx
mov ecx, 0
mov ecx, dword[hexAreas + (eax * 4)]
mov dword[areaMid], ecx

finishThis:

;-----MID STUFF Perims
mov rax, 0
mov rdx, 0
mov rcx, 0

mov eax, dword[length]
mov ecx, 2
div ecx

cmp edx, 0
jne isOdd2

mov ebx, hexPerims
mov ecx, 0 
dec eax
mov ecx, dword[ebx + (eax * 4)]
inc eax
add ecx, dword[ebx + (eax * 4)]
mov rax, 0
mov rdx, 0

mov eax, ecx
mov ecx, 2
div ecx
mov dword[perimMid], eax


jmp finishThis2
isOdd2:

mov rax, 0
mov eax, dword[length]
mov rcx, 0
mov ecx, 2
div ecx
mov ecx, 0
mov ecx, dword[hexPerims + (eax * 4)]
mov dword[perimMid], ecx

finishThis2:

; --- averages

mov rax, 0
mov rcx, 0
mov rdx, 0
mov eax, dword[perimSum]
mov ecx, dword[length]
div ecx
mov dword[perimAve], eax

mov rdx, 0
mov rax, 0
mov eax, dword[areaSum]
div ecx
mov dword[areaAve], eax


last:
	mov	eax, SYS_exit		; call code for exit
	mov	ebx, EXIT_SUCCESS	; exit program with success
	syscall