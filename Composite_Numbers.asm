TITLE: Composite numbers    (Program_4.asm)

; Author: Carlos Carrillo
; Course: CS_271                 Date: 02/13/2015
; Description:
; This program calculates prime numbers and works this way:
;	• The user is instructed to enter the number of primes to be displayed,
;	  and is prompted to enter an integer in the range [1 .. 400].
;	• The user enters a number, n, and the program verifies that 1 <= n <= 400.
;	• If n is out of range, the user is re-prompted until s/he enters a
;	  value in the specified range.
;	• The program then calculates and displays the all of the prime numbers
;	  up to and including the nth prime.
;	• The results should be displayed 10 primes per line with at least 3
;	  spaces between the numbers.

INCLUDE Irvine32.inc

.data
progTitle		BYTE "Welcome to the Composite Numbers Calculator Program!", 0
autor			BYTE "Created by Carlos Carrillo.", 0
ECMsg			BYTE "**EC=> Align the output columns.**", 0
directions1		BYTE "INSTRUCTIONS:", 0
directions2		BYTE "1) Think about how many composite numbers you would like to see.", 0
directions3		BYTE "2) Enter ONLY a number within the range of 1 to 400.", 0
directions4		BYTE "3) Watch and enjoy the composite numbers you wanted to see.", 0
promptNum		BYTE "How many composites numbers would you like to see? ", 0
errorMsg		BYTE "Your input is out of range!! Enter ONLY a number in between 1 and 400!", 0
FinalMsg1		BYTE "The Calculation is over. Thank you for your time!", 0
FinalMsg2		BYTE "Results certified by Carlos Carrillo. Goodbye my friend!!", 0
space           BYTE  "   ",9, 0  ;display 5 spaces between numbers
userInput		DWORD ?   ;stores the user's input
LOWEST	 =		1		  ;constant to set input lower limit
HIGHEST  =		400       ;constant to set input upper limit
LIMIT    =		400        ;constant for inner loop and number of elements per line
RESET    =		1         ;constant to reset counters
OUTERUP  =	    600       ;constant to set upper limit in the outer loop


;Global variables
.data?
outerVar	    DWORD ?   ;variable for outer loop variable
innerVar	    DWORD ?   ;variable for inner loop variable
remainResult	DWORD ?	  ;store the reminder to determine if isComposite
counterLine     DWORD ?   ;give a new line every 10 elements
displayedVar	DWORD ?   ;variable to be displayed for the user
isCompoFlag	    DWORD ?   ;flag variable to determine if it is a composite number

.code
main PROC

	call	introduction        ;call procedures in order
	call	getUserData
	call	showComposites
	call	farewell
	exit						;Exit to operating system

main ENDP

;-----------------------------------------------
;Procedure to introduce the program and show
;the instructions to the user.
;receives: Constant progTitle and autor
;returns:  The content of progTitle and autor
;preconditions:     none
;registers changed: edx
;-----------------------------------------------
introduction PROC

	call	CrLf
	mov		edx, OFFSET progTitle			;Program introduction
	call	writeString
	call	CrLf
	mov		edx, OFFSET autor
	call	writeString
	call	CrLf 

	call	CrLf
	mov		edx, OFFSET ECMsg				;EXTRA CREDIT statement #1
	call	WriteString
    call	CrLf

	call	CrLf
	mov		edx, OFFSET directions1			;Program instructions for user
	call	writeString
	call	CrLf
	mov		edx, OFFSET directions2
	call	writeString
	call	CrLf
	mov		edx, OFFSET directions3
	call	writeString
	call	CrLf
	mov		edx, OFFSET directions4
	call	writeString
	call	CrLf
	call	CrLf
	ret

introduction ENDP

;-----------------------------------------------
;Procedure to get and validate user's input.
;receives: Constant progTitle and autor
;returns:  The content of progTitle and autor
;preconditions:  UserInput must be in the range
;				 of [1...400] 
;registers changed: edx, eax
;-----------------------------------------------
getUserData PROC

errorReturn:
	mov		edx, OFFSET promptNum			;getting input from the user
    call	WriteString
    call	ReadInt
	call	CrLf
	mov		userInput, eax
	cmp		eax, LOWEST						;Input validation starts
    jl		displayError
    mov		eax, userInput
    cmp		eax, HIGHEST
	jg		displayError
	jmp		endGetUserData

displayError:								;Occur when (input < 1) or (input > 400)
    mov		edx, OFFSET errorMsg
    call	WriteString
    call	CrLf
    call	CrLf
    jmp		errorReturn

endGetUserData:
	ret

getUserData ENDP

;-----------------------------------------------
;Procedure to set the conditions to print the
;composite numbers expected by the user.
;receives: User input
;returns:  The actual composite numbers requested
;		   the user.
;preconditions:  UserInput must be in the range
;				 of [1...400] 
;registers changed: edx, eax, ecx
;-----------------------------------------------
showComposites PROC	

	mov		counterLine, 0					;Initialize counter for elements per line
	mov		displayedVar, 0					;Initialize counter for elements to be displayed
	mov		outerVar,	4					;Initialize outer loop variable
	mov		innerVar,	2					;Initialize inner loop variable
	mov		ecx, OUTERUP	                ;Set outer loop counter

outerLoop:							        ;Outer loop starts
	mov		eax, displayedVar
	cmp		eax, userInput					;Check if the loop reached the number desired by the user
	jl		continue				
	mov		ecx, RESET						;Reset outer loop when counter = userInput
continue:
	push	ecx								;Save outer loop count in the stack
	mov		ecx, LIMIT			     		;Set inner loop counter

	innerLoop:							    ;Inner loop starts
		mov		eax, innerVar
		cmp		eax, LIMIT
		jg		resetInnerVar
		jmp		keepGoing
	resetInnerVar:
		mov		innerVar, 2					;Reset inner loop variable when it reaches 10
	keepGoing:
		mov		eax, outerVar
		cmp		eax, innerVar
		je		exitInnerLoop
		mov		edx, 0						
		mov		eax, outerVar
		cdq
		mov		ebx, innerVar
		cdq
		div		ebx
		mov		remainResult, edx
		call	isComposite				    ;Call procedure to check if the number is composite
		mov		eax, isCompoFlag
		cmp		eax, 1						;If isCompoFlag = 1, the number is composite
		je		endInnerLoop                ;Finish inner loop after the composite number has been displayed
		jmp		exitInnerLoop				;Keep looping since isCompoFlag = 0
	endInnerLoop:
		mov		ecx, RESET					;Reset inner loop counter to terminate loop since isCompoFlag = 1
	exitInnerLoop:
		inc		innerVar
		loop	innerLoop                   ;Inner loop ends

	pop		ecx						     	;Recover outer loop count from the stack
	inc		outerVar
	loop	outerLoop						;Outer loop ends

	ret

showComposites ENDP

;-----------------------------------------------
;Procedure to actually print the composite numbers
;expected by the user.
;receives: remainResult, displayedVar, counterLine,
;		   outerVar, innerVar, userInput. 
;returns:  The actual composite numbers requested
;		   the user and isCompoFlag.
;preconditions:  UserInput must be in the range
;				 of [1...400] 
;registers changed: edx, eax, ecx
;-----------------------------------------------
isComposite  PROC

	mov		eax, remainResult
	cmp		eax, 0
	je		printNumber
	mov		isCompoFlag, 0
	jmp		exitIsComposite

printNumber:
	mov		isCompoFlag, 1
	mov		eax, counterLine
	cmp		eax, 9
	jg		newLine
	mov		eax, 0
	mov		eax, outerVar
	call	WriteDec
	mov		edx, OFFSET space
	call	writeString
	inc		displayedVar
	inc		counterLine
	jmp		exitIsComposite				

newLine:
	call	CrLf
	mov		counterLine, 0				 ;Reset counter for elements per line
	jmp		printNumber

exitIsComposite:
	mov		eax, displayedVar
	cmp		eax, userInput				 ;Check if the loop reach the number desired by the user
	je		resetCounters
	jmp		jumpReset				
resetCounters:
	mov		outerVar,	1				 ;Reset outer loop variable
	mov		innerVar,	1				 ;Reset inner loop variable
jumpReset:	
	ret

isComposite ENDP

;-----------------------------------------------
;Procedure to show a farewell message to the user,
;and terminate the program.
;receives: Constant FinalMsg1, FinalMsg2
;returns:  Farewell message
;preconditions:     none
;registers changed: edx
;-----------------------------------------------
farewell PROC

	call	CrLf
	call	CrLf
    mov		edx, OFFSET FinalMsg1	     ;Say bye to the user
    call	WriteString 
	call	CrLf 
	call	CrLf
    mov		edx, OFFSET FinalMsg2
    call	WriteString
    call	CrLf
    call	CrLf
	ret

farewell ENDP

END main

