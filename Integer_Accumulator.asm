TITLE: Integer Accumulator    (Program_3.asm)

; Author:	Carlos Carrillo
; Description: This program to perform the following tasks:
;	1. Display the program title and programmer’s name.
;	2. Get the user’s name, and greet the user.
;	3. Display instructions for the user.
;	4. Repeatedly prompt the user to enter a number. Validate the user input to be in [-100, -1] (inclusive). Count and accumulate the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)
;	5. Calculate the (rounded integer) average of the negative numbers.

INCLUDE Irvine32.inc

.data
progTitle	 BYTE "Welcome to the Integer Accumulator Program!", 0
autor		 BYTE "Created by Carlos Carrillo.", 0
ECMsg1		 BYTE "**EC: Line numbers during user input.**", 0
ECMsg2		 BYTE "**EC: Average as a floating-point number.**", 0
promptName	 BYTE "What is your name? ", 0
sayHello	 BYTE "Hello, ", 0
directions1	 BYTE "INSTRUCTIONS:", 0
directions2	 BYTE "* Enter negative numbers in the range of [-100, -1]", 0
directions3	 BYTE "* Enter a non-negative number to stop the calculation and see the results.", 0
promptNum	 BYTE "Enter a number: ", 0
resultsMsg	 BYTE "RESULTS:", 0
accumulMsg 	 BYTE "-> Valid numbers entered =  ", 0
sumMsg		 BYTE "-> Sum of valid numbers  = ", 0
averageMsg	 BYTE "-> Rounded average       = ", 0
fpAveMsg	 BYTE "EC: Exact average with floating point = ", 0
FinalMsg	 BYTE "The Calculation is over! Thank you for your time, ", 0
errorMsg     BYTE "Your input is out of range!! Enter any number in between -100 and -1 ONLY!", 0
excMark		 BYTE	"!!", 0
bullet		 BYTE	") ", 0
userName	 BYTE 32 DUP(0)
userInput    DWORD ?   ;user's input
nameCount    DWORD ?
countNum     DWORD ?   ;count the numbers entered by the user
accumuNum    DWORD 0
quotResult   DWORD 0
remainder	 DWORD ?

LOWEST	 = -100      ;constant to set lower limit
HIGHEST  = -1        ;constant to set upper limit
ROUNDVAL =  5	     ;constant to round the average up

;EC variables/constants (floating point)  
floatingMsg		BYTE	"Average with floating point:    ", 0
point			BYTE	".", 0
negOperator		DWORD  -10
posOperator		DWORD	10
tempOperator	DWORD	?
floatOutput		DWORD	?

.code
main PROC
	mov		edx, OFFSET progTitle       ;INTRODUCTION
    call	WriteString
    call	CrLf
    mov		edx, OFFSET autor  
    call	WriteString
    call	CrLf
    call	CrLf

	mov		eax, 12+(0*16)              ;Red color for EC statement, so you won't miss it ;-)
	call	setTextColor

	mov		edx, OFFSET ECMsg1			;EXTRA CREDIT statement #1
	call	WriteString
    call	CrLf
	mov		edx, OFFSET ECMsg2			;EXTRA CREDIT statement #2
	call	WriteString
    call	CrLf
	call	CrLf

	mov		eax, 15+(0*16)              ;Color back to normal
	call	setTextColor
  
	mov		edx, OFFSET promptName      ;Getting user's name'
    call	WriteString
    mov		edx, OFFSET userName	
	mov		ecx, SIZEOF userName		;Specify max characters
	call	ReadString
	mov		nameCount, eax 

	mov		edx, OFFSET sayHello	    ;Greeting the user
	call	WriteString
	mov		edx, OFFSET userName 
	call	WriteString 
	mov		edx, OFFSET excMark
    call	WriteString
    call	CrLf
    call	CrLf
	
	mov		edx, OFFSET directions1     ;Instructions
	call	WriteString
    call	CrLf 
	mov		edx, OFFSET directions2
	call	WriteString
    call	CrLf
	mov		edx, OFFSET directions3
	call	WriteString
    call	CrLf
	call	CrLf
	mov		ecx, 0		                ;Initialize accumulator for loop

inputLoop:
	inc 	countNum
	mov		eax, countNum
	call	WriteDec
	mov		edx, OFFSET bullet
	call	WriteString
	mov		edx, OFFSET promptNum
	call	WriteString
	call	ReadInt
	mov		userInput, eax
    cmp     eax, LOWEST					;Input validation starts here
    jl		displayError
	cmp     eax, HIGHEST
	jg		calculation
	add		eax, accumuNum
	mov		accumuNum, eax
	loop	inputLoop 
	 
displayError:                           ;Occur when (input < -100) or (input > -1)
	call	CrLf
    mov		edx, OFFSET errorMsg
    call	WriteString
	mov		countNum, 0
    call	CrLf
    call	CrLf
    jmp		inputLoop
	 
calculation:
	jz		final						 ;Jump to end if input = 0
	cmp		countNum, 1
	je		final						 ;Jump to end if a non-negative values are entered
	call	CrLf
	mov		edx, OFFSET resultsMsg       ;Results header
	call	WriteString
	call	CrLf
	mov		edx, OFFSET accumulMsg		 ;Print the number of valid values entered
	call	WriteString
	sub		countNum, 1
	mov		eax, countNum
	call	WriteDec
	call	CrLf
	mov		edx, OFFSET sumMsg			 ;Print sum of numbers accumulated
	call	WriteString
	mov		eax, accumuNum
	call	WriteInt
	call	CrLf

	mov		edx, OFFSET averageMsg		 ;Procedure to round average 
	call	WriteString
	mov		eax, 0
	mov		eax, accumuNum
	cdq
	mov		ebx, countNum
	idiv	ebx
	mov		quotResult, eax
	mov		remainder, edx
           
	mov		eax, remainder		         ;Determine size of floating point		 
	mul		negOperator
	mov		tempOperator, eax
	mov		eax, 0
	mov		eax, tempOperator
	cdq
	mov		ebx, countNum
	div		ebx
	cmp		eax, ROUNDVAL
	jg		roundUp
	jmp		noRoundUp

roundUp:								 ;Round UP if floating point < .5
	mov		eax, quotResult
	sub		eax, 1
	call	WriteInt
	call	CrLf
	call	CrLf
	jmp		colorChange

noRoundUp:					             ;NO rounding up when floating point < .5
	mov		eax, quotResult
	call	WriteInt
	call	CrLf
	call	CrLf

colorChange:
	mov		eax, 12+(0*16)               ;Red color for EC line, so you won't miss it ;-)
	call	setTextColor
	mov		eax, quotResult

	mov		edx, OFFSET fpAveMsg		 ;Print average with floating point
	call	WriteString
	mov		edx, quotResult
	call	WriteInt
					  
	mov		edx, OFFSET point            ;First decimal place after floating point
	call	WriteString
	mov		eax, remainder
	mul		negOperator
	mov		tempOperator, eax
	mov		eax, 0
	mov		eax, tempOperator
	cdq
	mov		ebx, countNum
	div		ebx
	call	WriteDec

	mov		remainder, edx               ;Second decimal place after floating point
	mov		eax, remainder
	mul		posOperator
	mov		tempOperator, eax
	mov		eax, 0
	mov		eax, tempOperator
	cdq
	mov		ebx, countNum
	div		ebx
	call	WriteDec

	mov		remainder, edx               ;Thrid decimal place after floating point
	mov		eax, remainder
	mul		posOperator
	mov		tempOperator, eax
	mov		eax, 0
	mov		eax, tempOperator
	cdq
	mov		ebx, countNum
	div		ebx
	call	WriteDec
	call	CrLf

	mov		eax, 15+(0*16)               ;Color back to normal
	call    setTextColor
	
final:									 ;Last set of instructions
    call	CrLf
    mov		edx, OFFSET FinalMsg	     ;Say bye to the user
    call	WriteString  
    mov		edx, OFFSET userName
    call	WriteString
    mov		edx, OFFSET excMark
    call	WriteString 
    call	CrLf
    call	CrLf

	exit	                             ;Exit to operating system

main ENDP
END main



