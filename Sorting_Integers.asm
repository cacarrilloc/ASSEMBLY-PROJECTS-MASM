TITLE: Sorting Random Integers    (Program_5.asm)

; Author: Carlos Carrillo
; Course: CS_271                 Date: 02/22/2015

; Description:
; This program performs the following actions:
;	1. Introduce the program.
;	2. Get a user request in the range [min = 10 .. max = 200].
;	3. Generate request random integers in the range [lo = 100 .. hi = 999], storing 
;      them in consecutive elements of an array.
;	4. Display the list of integers before sorting, 10 numbers per line.
;	5. Sort the list in descending order (i.e., largest first).
;	6. Calculate and display the median value, rounded to the nearest integer. 
;   7. Display the sorted list, 10 numbers per line.


INCLUDE Irvine32.inc

; Global Constants and variables
LOWEST	   =	10		  ;constant to set userInput lower limit
HIGHEST    =	200       ;constant to set userInput upper limit and ARRAY_SIZE
HIGHRANGE  =	999		  ;hight limit for the random integers in the range
LOWRANGE   =	100	      ;low limit for the random integers in the range

.data
progTitle		BYTE "Welcome to the Sorting Random Integers Program!", 0
autor			BYTE "Created by Carlos Carrillo.", 0
description1	BYTE "DESCRIPTION:", 0
description2	BYTE "This program generates random numbers, displays and unsorted list,", 0
description3	BYTE "sorts the list, calculates the median value, and displays the list", 0
description4	BYTE "sorted in descending order.", 0
directions1		BYTE "INSTRUCTIONS:", 0
directions2		BYTE "1) Enter any number in the range of [10..200]", 0
directions3		BYTE "2) See the list of unsorted random numbers.", 0
directions4		BYTE "3) See the median range number.", 0
directions5		BYTE "4) See the the list of sorted numbers.", 0
promptNum		BYTE "How many numbers would you like to see? ", 0
arrayBefore     BYTE "THE UNSORTED LIST IS: ", 0
medianMsg		BYTE "==> MEDIAN = ",0
arrayAfter      BYTE "THE SORTED LIST IS: ", 0
errorMsg		BYTE "Your input is out of range!! Enter ONLY a number in the range of [10..200]!", 0
space           BYTE "   ", 0  ;display 3 spaces between numbers
FinalMsg1		BYTE "Thank you for your time!", 0
FinalMsg2		BYTE "Results certified by Carlos Carrillo. Goodbye my friend!!", 0
arrayList		DWORD HIGHEST DUP(?)  ;array declaration
userInput		DWORD ?   ;stores the user's input

.code
main PROC

	push	OFFSET directions5      ;pass ALL introduction strings by reference
	push	OFFSET directions4
	push	OFFSET directions3
	push	OFFSET directions2
	push	OFFSET directions1
	push	OFFSET description4
	push	OFFSET description3
	push	OFFSET description2
	push	OFFSET description1
	push	OFFSET autor
	push	OFFSET progTitle       
	call	introduction            ;First procedure
	
	push	OFFSET errorMsg         ;pass errorMsg variable by reference
	push	OFFSET promptNum        ;pass promptNum variable by reference
	push	OFFSET userInput	    ;pass userInput variable by reference
	call	getUserData

	call	Randomize				;from Irvine64: Seeds the random number 
	                                ;generator with a unique value.              
	
	push	OFFSET arrayBefore		;pass/save header message into the stack by reference
	push	OFFSET arrayList		;pass/save array into the stack by reference
	push	userInput	            ;pass/save userInput into the stack by value
	call	fillArray

	push	OFFSET space       		;pass/save space string the stack by reference
	push	OFFSET arrayList		;pass/save array into the stack by reference
	push	userInput	            ;pass/save userInput into the stack by value
	call	displayList

	push	OFFSET arrayList		;pass/save array into the stack by reference
	push	userInput	            ;pass/save userInput into the stack by value
	call	sortList
	
	push	OFFSET arrayAfter		;pass/save header messages into the stack by reference
	push	OFFSET medianMsg
	push	OFFSET arrayList		;pass/save array into the stack by reference
	push	userInput	            ;pass/save userInput into the stack by value
	call	displayMedian

	push	OFFSET space       		;pass/save space string the stack by reference
	push	OFFSET arrayList		;pass/save array into the stack by reference
	push	userInput	            ;pass/save userInput into the stack by value
	call	displayList

	push    OFFSET FinalMsg2	    ;pass/save messages into the stack by reference
	push    OFFSET FinalMsg1
	call	farewell				;Final procedure
	exit							;Exit to operating system

main ENDP

;-------------------------------------------------------------
;Procedure to display the program introduction, description, 
;and instructions to the user.
;Receives:          Global constant variables
;Returns:           Nothing 
;Preconditions:     Global constants must be strings
;Registers changed: edx
;-------------------------------------------------------------
introduction PROC

	push	ebp					;by convention, save ebp
	mov		ebp, esp            ;set stack pointer

	mov		edx, [ebp + 8]		;dereference and print progTitle
	call	writeString
	call	CrLf
	mov		edx, [ebp + 12]     ;dereference and print autor
	call	writeString
	call	CrLf 

	call	CrLf
	mov		edx, [ebp + 16]     ;dereference and print description strings
	call	WriteString
    call	CrLf
	mov		edx, [ebp + 20]    	
	call	WriteString
    call	CrLf
	mov		edx, [ebp + 24]    	
	call	WriteString
    call	CrLf
	mov		edx, [ebp + 28]     	
	call	WriteString
    call	CrLf

	call	CrLf
	mov		edx, [ebp + 32]		;dereference and print instruction strings
	call	writeString
	call	CrLf
	mov		edx, [ebp + 36]
	call	writeString
	call	CrLf
	mov		edx, [ebp + 40]
	call	writeString
	call	CrLf
	mov		edx, [ebp + 44]
	call	writeString
	call	CrLf
	mov		edx, [ebp + 48]
	call	writeString
	call	CrLf
	call	CrLf
	
	pop		ebp					;restore ebp
	ret		44					;clean the stack from strings 
	
introduction ENDP

;---------------------------------------------------------------
;Procedure to get and validate user's input.
;Receives:          @userInput variable and Global constants
;Returns:           userInput as a variable with certain value.
;Preconditions:     userInput must be in the range of [1..200] 
;Registers changed: edx, eax
;---------------------------------------------------------------
getUserData PROC

	push	ebp						   ;by convention, save ebp
	mov		ebp, esp                   ;set stack pointer
	mov		ebx, [ebp + 8]			   ;dereference userInput and save into ebx    

errorReturn:
		mov		edx, [ebp + 12]		   ;dereference and print promptNum 
		call	WriteString
		call	ReadInt
		call	CrLf
		mov     [ebx], eax			   ;deference ebx to save userInput variable
		cmp		eax, LOWEST			   ;Input validation starts
		jl		displayError
		mov		eax, userInput
		cmp		eax, HIGHEST
		jg		displayError
		jmp		endGetUserData

displayError:						   ;Occur when (input < 1) or (input > 200)
		mov		edx, [ebp + 16]		   ;dereference and print errorMsg
		call	WriteString
		call	CrLf
		call	CrLf
		jmp		errorReturn

endGetUserData:
		pop		ebp					    ;restore ebp
		ret		12						;clean the stack from @userInput, @errorMsg, and @promptNum 

getUserData ENDP

;-------------------------------------------------------------------
; Procedure to fill an array with random numbers
; Receives:	         @arrayList by reference and userInput by value.
; Returns:	         Nothing
; Preconditions:	 userInput must be in the range of [10..200]
; Registers Changed: eax, ecx, esi
;-------------------------------------------------------------------
fillArray PROC 

	push	ebp					 ;by convention, save ebp into the stack
	mov		ebp, esp		     ;set stack pointer
	mov		esi, [ebp + 12]      ;dereference arrayList and save into esi 
	mov		ecx, [ebp + 8]       ;dereference userInput and save into ecx (counter)

	mov		edx, [ebp + 16]		 ;dereference and print unsorted-list header
	call	WriteString			   
	call	CrLf

fillingLoop:
	  mov		eax, HIGHRANGE	 ;generate random integers between 100 - 999 in EAX
	  sub		eax, LOWRANGE
	  inc		eax
	  call	    RandomRange         
	  add		eax, LOWRANGE
	  mov		[esi], eax		 ;insert random element (Register Indirect Addressing)
	  add		esi, 4			 ;increase counter to get to next array position
	  loop		fillingLoop

	pop  ebp					 ;restore ebp
	ret  12						 ;empty stack from @arrayList and userInput

fillArray ENDP

;-------------------------------------------------------------------
; Procedure to display the array elements
; Receives:	         @arrayList by reference and userInput by value.
; Returns:	         Nothing
; Preconditions:     userInput must be in the range of [10..200]
; Registers Changed: eax, ecx, ebx, edx
;-------------------------------------------------------------------
displayList PROC

	push	ebp					  ;by convention, save ebp into the stack
	mov		ebp, esp              ;set stack pointer
	mov		esi, [ebp + 12]       ;dereference arrayList and save into esi 
	mov		ecx, [ebp + 8]        ;dereference userInput and save into ecx (counter)
	mov		ebx, 0			      ;Initialize counter for elements per line

	displayNum:
	mov		eax, [esi]			  ;get a number (Register Indirect Addressing)
	call	WriteDec			  ;display the number
	mov		edx, [ebp + 16]		  ;dereference and print space string 
	call	WriteString
	inc		ebx     			  ;increment counter
	mov		eax, ebx
	cmp		eax, LOWEST
	jl		endOfLoop
	call	CrLf				  ;start a new line after 10 elements
	mov		ebx, 0		          ;reset counter

	endOfLoop:
	add		esi, 4				  ;next array position
	loop	displayNum
	call	CrLf
	
	pop		ebp					  ;restore ebp
	ret		12					  ;empty stack from @arrayList and userInput

displayList ENDP

;---------------------------------------------------------------------
; Procedure to sort an array of 32-bit signed integers in descending
; order, using the bubble sort algorithm.
; Receives:			 @arrayList by reference 
; Returns:			 Nothing
; Preconditions:	 userInput must be in the range of [10..200]
; Registers Changed: eax, ecx, ebx, edx
;----------------------------------------------------------------------
sortList PROC

	push	ebp					     ;by convention, save ebp into the stack
	mov		ebp, esp				 ;set stack pointer
	mov		ecx, [ebp + 8]           ;dereference userInput and save into ecx (counter)
	dec		ecx					     ;decrement count by 1

	outerLoop:
		push	ecx				     ;save outer loop counter
		mov		esi, [ebp + 12]      ;point to first value
	
		innerLoop:
			mov		eax, [esi]       ;get array value
			cmp		[esi+4], eax     ;compare a pair of values
			jle		noSwitching      ;if [ESI] >= [ESI+4], no exchange
			xchg	eax, [esi+4]     ;exchange the pair 
			mov		[esi], eax

		noSwitching:
			add		esi,4            ;move both pointers forward
			loop	innerLoop
		
	pop		ecx 			         ;retrieve outer loop count
	loop	outerLoop				 ;else repeat outer loop

	pop		ebp						 ;restore ebp
	ret		8						 ;empty stack from @arrayList 

sortList ENDP

;----------------------------------------------------------------------
; Procedure to calculate and display the median value of the elements
; rounded to the nearest integer.
; Receives:			 @arrayList by reference and userInput by value.
; Returns:			 Nothing
; Preconditions:	 userInput must be in the range of [10..200]
; Registers Changed: eax, ecx, ebx, edx
;----------------------------------------------------------------------
displayMedian PROC

	push	ebp					  ;by convention, save ebp into the stack
	mov		ebp, esp			  ;set stack pointer
	mov		esi, [ebp + 12]       ;dereference arrayList and save into esi 
	mov		eax, [ebp + 8]        ;dereference userInput to perform division

	mov		edx, 0				  ;div operation to find middle value and even/odd feature
	mov		ebx, 2
	div		ebx
	mov		ecx, eax			  ;the dividend is going to be the loop counter

	medianLoop:					  ;loop to find "middle" value	
		add		esi, 4			  ;increment array position
		loop	medianLoop

	mov		eax, edx
	cmp		eax, 0				  ;check reminder		
	je		isEven
	mov		edx, [ebp + 16]		  ;dereference and print median header
	call	CrLf
	call	WriteString
	mov		eax, [esi]		      ;esi contains the odd median
	call	WriteDec
	call	CrLf
	call	CrLf
	jmp		funcFinal

	isEven:
	mov		eax, [esi-4]	      ;second middle element
	add		eax, [esi]            ;first middle element
	mov		edx, 0			      ;div operation to find even median
	mov		ebx, 2
	div		ebx
	mov		edx, [ebp + 16]		  ;dereference and print median header
	call	CrLf
	call	WriteString
	call	WriteDec
	call	CrLf
	call	CrLf

funcFinal:
	mov		edx, [ebp + 20]		  ;dereference and print sorted-list header
	call	WriteString			   
	call	CrLf

	pop  ebp					  ;restore ebp
	ret  16						  ;empty stack from @arrayList and userInput

displayMedian ENDP

;------------------------------------------------------------------
;Procedure to display a farewell message and terminate the program.
;receives:          Constant FinalMsg1, FinalMsg2
;returns:           Nothing (Farewell message)
;preconditions:     none
;registers changed: edx
;------------------------------------------------------------------
farewell PROC

	push	ebp					  ;by convention, save ebp into the stack
	mov		ebp, esp              ;set stack pointer

	call	CrLf
    mov		edx, [ebp + 8]		  ;dereference and print farewell message
    call	WriteString 
	call	CrLf
    mov		edx, [ebp + 12]		  ;dereference and print farewell message
    call	WriteString
    call	CrLf
    call	CrLf

	pop  ebp					  ;restore ebp
	ret  8						  ;empty stack 

farewell ENDP

END main

