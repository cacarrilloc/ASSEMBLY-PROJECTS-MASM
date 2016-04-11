TITLE: low-level I/O procedures    (Program_6.asm)

; Author: Carlos Carrillo
; Course: CS_271                 Date: 03/07/2016

; Description:
; This program gets 10 valid integers from the user and stores the numeric values in an array. 
; Then it displays the integers, their sum and average. In order to do that, this program:
;
;	• Implements ReadVal and WriteVal procedures for unsigned integers.
;	• Implement macros getString and displayString. The macros use Irvine’s ReadString to get 
;	  input from the user, and WriteString to display output.
;	• Makes getString macro displays a prompt, then get the user’s keyboard input into a memory location.
;	• Makes displayString macro takes the string stored in a specified memory location.
;	• Makes readVal procedure invoke the getString macro to get the user’s string of digits and convert. 
;	  the digit string to numeric, while validating the user’s input.
;	• Makes writeVal procedure convert a numeric value to a string of digits, and invoke the displayString
;	  macro to produce the output.

INCLUDE Irvine32.inc

; Global Constants 
ZEROASCII   =	48		  ;constant to represent '0' in Ascii code'
NINEASCII   =	57        ;constant to represent '9' in Ascii code'
TENLIMIT    =   10		  ;constant to set inputArray size and digit place in readVal and writeVal.

.data
progTitle		BYTE " *** Welcome to the low-level I/O procedures program!***", 0
autor			BYTE " *** Created by Carlos Carrillo.***", 0
description1	BYTE " DESCRIPTION:", 0
description2	BYTE " This program receives 10 unsigned numbers as ASCII strings, converts them", 0
description3	BYTE " into integers values, and then displays them along with their sum and average.", 0
directions1		BYTE " INSTRUCTIONS:", 0
directions2		BYTE " 1) Enter 10 unsigned numbers.", 0
directions3		BYTE " 2) See the numbers you entered displayed on the screen.", 0
directions4		BYTE " 3) See the sum of these numbers displayed on the screen.", 0
directions5		BYTE " 4) See the average of these numbers displayed on the screen.", 0
promptNum		BYTE " Please enter an unsigned number: ", 0
numberMsg		BYTE " You entered the following numbers: ",0
sumMsg		    BYTE " The SUM of your numbers is: ", 0
avgMsg		    BYTE " The ROUNDED average is: ", 0
errorMsg		BYTE " ERROR: You entered an invalid number or your number was too big!", 0
spaceComma      BYTE ", ", 0  ;display comma and 2 spaces between numbers
space           BYTE " ", 0  ;display comma and 2 spaces between numbers
FinalMsg1		BYTE " Thank you for your time!", 0
FinalMsg2		BYTE " Results certified by Carlos Carrillo. Goodbye my friend!!", 0
sumValue		DWORD ?  ;variable to store the sum
avgValue		DWORD ?  ;variable to store the average

;Array variables
userInput		BYTE  255 DUP(0)        ;string array to store user's input
numericArray	DWORD TENLIMIT DUP(0)   ;array to store converted values 
stringOutput	BYTE  32 DUP(?);        ;temporary string to store and print results in WriteVal

;------------------------------------------------------------------------------------
; Macro:		   mGetString
; Description:     Displays a prompt message and gets the user's keyboard input into 
;				   a memory location.
; Receives:        Offset of a string array, SIZEOF string array, and string message.   
; Parameters:      promptMsg, stringInput, stringSize
; Registers used:  ecx, edx
;------------------------------------------------------------------------------------
mGetString	 MACRO promptMsg, stringInput, stringSize	

	push	edx					;save registers needed
	push	ecx
	mov		edx, promptMsg		;take numberMsg offset
	call	WriteString			;display message
	mov  	edx, stringInput	;take userInput offset
	mov  	ecx, stringSize		;take SIZEOF numberMsg offset
	call 	ReadString
	pop		ecx					;restore registers
	pop		edx

ENDM

;-----------------------------------------------------------------------------
; Macro:		   mDisplayString
; Description:     Displays the string stored in a specified memory location.
; Receives:        Address/offset of a string.
; Parameters:      stringDisplayed
; Registers used:  edx
;-----------------------------------------------------------------------------
mDisplayString MACRO stringDisplayed

	push	edx						;save register needed
	mov		edx, stringDisplayed	;take string offset
	call	WriteString				;display string/value
	pop		edx						;restore register

ENDM

;------------------------------------------------------------------------
;Procedure:         Main
;Description:       Call all the procedures necessary to run the program.
;Receives:          All variable offsets
;Returns:           Nothing 
;Preconditions:     None
;Registers changed: None (directly)
;------------------------------------------------------------------------
.code
main PROC
	push	OFFSET directions5		;pass ALL introduction strings by reference
	push	OFFSET directions4
	push	OFFSET directions3
	push	OFFSET directions2
	push	OFFSET directions1
	push	OFFSET description3
	push	OFFSET description2
	push	OFFSET description1
	push	OFFSET autor
	push	OFFSET progTitle       
	call	introduction            ;call introduction procedure
	call	CrLf

	push	OFFSET errorMsg         ;pass errorMsg string  by reference
	push	OFFSET promptNum        ;pass promptNum string  by reference
	push	OFFSET numericArray	    ;pass array by reference
	push	SIZEOF userInput		;pass the size of userInput by reference
	push	OFFSET userInput	    ;pass userInput string array by reference
	call	readVal					;call readVal procedure
	call	CrLf
	
	push	OFFSET space		    ;pass spaces string by reference
	push	OFFSET spaceComma	    ;pass spaceComma string by reference
	push	OFFSET numberMsg        ;pass numberMsg string by reference
	push	OFFSET stringOutput		;pass string array by reference
	push	OFFSET numericArray	    ;pass array of integers by reference
	call	displayInput			;call displayInput procedure
	call	CrLf

	push	OFFSET sumMsg           ;pass sumMsg string by reference
	push	OFFSET sumValue         ;pass sumValue variable by reference
	push	OFFSET stringOutput		;pass string array by reference
	push	OFFSET numericArray	    ;pass array of integers by reference
	call	displaySum				;call displaySum procedure
	call	CrLf
	
	push	OFFSET avgMsg           ;pass avgMsg string by reference
	push	OFFSET stringOutput		;pass string array by reference
	push	OFFSET avgValue         ;pass avgValue variable by reference
	push	OFFSET sumValue         ;pass sumValue variable by reference
	call	displayAvg				;call displayAvg procedure
	call	CrLf
	
	push	OFFSET space			;pass message strings by reference
	push    OFFSET FinalMsg2	    
	push    OFFSET FinalMsg1
	call	farewell				;call farewell procedure
	exit							;exit to operating system

main ENDP

;---------------------------------------------------------------------
;Procedure:		  Introduction 
;Description:	  Display the program introduction, description, 
;				  and directions for the user by calling a macro.
;Receives:        Offsets of introduction messages/strings
;Returns:         Nothing 
;Preconditions:	  All values have to be passed by reference.
;Registers used:  None
;----------------------------------------------------------------------
introduction PROC
	push	ebp						;by convention, save ebp
	mov		ebp, esp				;set stack pointer

	call	CrLf
	mDisplayString [ebp + 8]		;call macro to print progTitle
	call	CrLf
	mDisplayString [ebp + 12]		;call macro to print autor
	call	CrLf 

	call	CrLf
	mDisplayString [ebp + 16]		;call macro to print description strings
    call	CrLf
	mDisplayString [ebp + 20]    	
    call	CrLf
	mDisplayString [ebp + 24]    	
    call	CrLf

	call	CrLf
	mDisplayString [ebp + 28]		;call macro to print instruction strings
	call	CrLf
	mDisplayString [ebp + 32]
	call	CrLf
	mDisplayString [ebp + 36]
	call	CrLf
	mDisplayString [ebp + 40]
	call	CrLf
	mDisplayString [ebp + 44]
	call	CrLf
	
	pop		ebp						;restore ebp
	ret		40						;clean the stack  
	
introduction ENDP

;---------------------------------------------------------------------------------------------
; Procedure:       ReadVal
; Description:     Invokes the mGetString macro to get the user's string of digits and
;				   converts the digits string to integers, while validating the user's input.
; Receives:        Offsets of userInput array, numericArray array, SIZEOF userInput, 
;				   and message strings
; Returns:         Array of integers filled with converted string values.
; Preconditions:   All values have to be passed by reference.
; Registers used:  eax, ebx, ecx, edx, edi, esi
;---------------------------------------------------------------------------------------------
readVal PROC
	push	ebp							;by convention, save ebp
	mov		ebp, esp					;set stack pointer
	mov		edi, [ebp+16]				;point to first empty spot in numericArray
	mov		ecx, TENLIMIT				;set counter
	
	outerLoop:
		push	ecx		 				;save outerLoop counter

	  askAgain:
		mGetString [ebp+20], [ebp+8], [ebp+12]	;call macro

		mov		edx, [ebp+8]			;transfer userInput address to edx   
		mov		esi, edx				;point to the very first element
		mov		ecx, eax				;innerLoop counter
		cld
		mov		eax, 0					;reset eax for conversion purposes	
		mov		ebx, 0					;accumulator for digit position

		innerLoop:						;load the string byte by byte
			lodsb						;Moves byte at [esi] into the AL register
			cmp		ax, ZEROASCII		;input validation: check ascii range, '0' = 48d
			jb		displayError
			cmp		ax, NINEASCII		;input validation: check ascii range, '9' = 57d
			ja		displayError
			sub		ax, ZEROASCII		;find decimal value of digit
			xchg	eax, ebx			;place converted value in accumulator
			mov		edx, TENLIMIT		;digit position operant
			mul		edx					;multiply by 10 to correctly place the digit
			jc		displayError		;check for overflow to see if input exceed 32-bit
			jnc		noError				
		  displayError:
			call	CrLf
			mDisplayString	[ebp+24]	;call macro to display error message
			call	CrLf
			call	CrLf
			mov		ecx, 0
			jmp		askAgain			;ask for a new valid input
		  noError:
			add		eax, ebx			;add the digit to set correct spot in the final integer
			xchg	eax, ebx			;update accumulator with latest decimal value
			loop	innerLoop			;process next byte

		xchg	ebx, eax				;save final converted string into eax 
		stosd							;moves byte from eax register to memory at [edi]
		pop		ecx						;restore outer loop counter
		loop	outerLoop
			
	pop ebp								;restore ebp
	ret 20								;clean the stack  

readVal ENDP

;----------------------------------------------------------------------------------
; Procedure:       SeeInput 
; Description:     Call writeVal procedure in order to display the integer values 
;				   previously stored in numericArray during the conversion process
;		           performed in readVal. 	
; Receives:        Offsets of numericArray, stringOutput, and string messages.
; Returns:         Nothing (just displays integer values). 
; Preconditions:   All values have to be passed by reference.
; Registers used:  eax, ecx, esi
;----------------------------------------------------------------------------------
displayInput  PROC
	push	ebp						;by convention, save ebp
	mov		ebp, esp				;set stack pointer

	mDisplayString [ebp+16]			;call macro to display header message
	call	CrLf
	call	CrLf
	mDisplayString [ebp+24]			;call macro to display cosmetic single space ;-)

	mov		esi, [ebp+8]			;save @numericArray esi
	mov		ecx, TENLIMIT			;set loop counter
	cld								;direction = forward

	displayLoop: 
		push	[ebp+12]			;push temporary string to store converted value
		push	esi					;push current array value to be converted by writeVal 	
		call	writeVal			;call writeVal
		lodsd						;load [ESI] into EAX
		cmp		ecx, 1				;avoid comma after the last array element
		je		endLoop
		mDisplayString [ebp+20]		;call macro to display comma and space
	  endLoop:
		loop	displayLoop
	
	pop ebp							;restore ebp
	ret 20							;clean the stack  

displayInput ENDP

;-------------------------------------------------------------------------------------
; Procedure:       DisplaySum 
; Description:     Call writeVal procedure in order to display the sum of the integer  
;				   values previously stored in numericArray during the conversion 
;		           process performed in readVal. 	
; Receives:        Offsets of numericArray, stringOutput, and string message.
; Returns:         Nothing (just displays an integer value). 
; Preconditions:   All values have to be passed by reference.
; Registers used:  eax, ecx, ebx, edi, esi
;--------------------------------------------------------------------------------------
displaySum  PROC
	push	ebp						;by convention, save ebp
	mov		ebp, esp				;set stack pointer

	call	CrLf
	mDisplayString [ebp+20]			;call macro to display header message 

	mov		esi, [ebp+8]			;save @numericArray into esi
	mov		ecx, TENLIMIT			;set loop counter
	mov		ebx, 0					;accumulator	
	cld								;direction = forward

	sumLoop: 
		lodsd						;load [ESI] into EAX
		add		eax, ebx			;perform cumulative addition
		xchg	eax, ebx
		loop	sumLoop

	xchg	eax, ebx				;load eax with total sum value
	mov		edi, [ebp+16]
	mov		[edi], eax
	push	[ebp+12]				;push temporary string to store converted value
	push	edi						;push total sum value to be converted by writeVal 	
	call	writeVal				;call writeVal

	pop ebp							;restore ebp
	ret 16							;clean the stack  

displaySum ENDP

;-------------------------------------------------------------------------------------
; Procedure:       DisplayAvg
; Description:     Call writeVal procedure in order to display the average of the integer  
;				   values previously stored in numericArray during the conversion 
;		           process performed in readVal. 	
; Receives:        Offsets of numericArray, stringOutput, and string message.
; Returns:         Nothing (just displays an integer value). 
; Preconditions:   All values have to be passed by reference.
; Registers used:  eax, ecx, ebx, edi, esi
;--------------------------------------------------------------------------------------
displayAvg  PROC
	push	ebp						;by convention, save ebp
	mov		ebp, esp				;set stack pointer

	call	CrLf
	mDisplayString [ebp+20]			;call macro to display header message

	mov		edi, [ebp+8]			;save @sumValue into edi
	mov		eax, [edi]				;dereference sumValue and save it into eax

	mov		ebx, TENLIMIT			;prepare registers for average calculation
	mov		edx, 0
	div		ebx						;get initial average value in eax
						
	xchg	ecx, eax				;check if average needs to be rounded up	
	xchg	eax, edx				;save reminder in eax 
	mov		edx, 2					;do operations
	mul		edx
	cmp		eax, ebx 
	xchg	eax, ecx
	mov		edi, [ebp+12]			;save @avgValue into edi
	mov		[edi], eax				;write initial average value into avgValue
	jb		noRoundedAvg			
	inc		eax						;increase avgValue by 1 if rounding up needed
	mov		[edi], eax				;re-write average value into avgValue

noRoundedAvg:							 
	push	[ebp+16]				;push temporary string to store converted value
	push	edi						;push @avgValue with final value to be converted into a string	
	call	WriteVal
	
	pop ebp							;restore ebp
	ret 16							;clean the stack  

displayAvg ENDP

;-----------------------------------------------------------------------------
; Procedure:       WriteVal 
; Description:     Convert a numeric value to a string of digits, and invoke 
;			       displayString macro to produce the output.
; Receives:        Offsets of an integer value and stringOutput.
; Returns:         Converted string of digits from an integer value. 
; Preconditions:   All values have to be passed by reference.
; Registers used:  eax, ebx, ecx, edx, edi, esi
;-----------------------------------------------------------------------------
writeVal  PROC
	push	ebp						;by convention, save ebp
	mov		ebp, esp				;set stack pointer
	pushad							;save all registers (totally necessary)

	mov		edi, [ebp+8]			;point to value to be converted
	mov		eax, [edi]				;dereference number to be converted
	mov		ecx, TENLIMIT			;set recurrent divisor
	xor		bx, bx					;set and clear digit counter for getDigitLoop 

	getDigitLoop:
		xor		edx, edx			;set and clear edx for division
		div		ecx					;start getting reminders for conversion
		push	dx					;push first digit to stack
		inc		bx					;increase counter
		cmp		eax, 0				;if quotient = 0 we're done with the whole number
		jne		getDigitLoop

	mov		esi, [ebp+12]			;point to empty spot in stringOutput
	mov		cx, bx					;copy counter from getDigitLoop

	conversionLoop:
		pop		ax		            ;pop digit from stack
		add		ax, ZEROASCII		;actual conversion to ascii
		mov		[esi], ax			;write converted value into stringOutput
		mDisplayString esi          ;call macro to display converted digit
		loop	conversionLoop		

	mov		ebx, 0					;reset digit counter
	popad							;restore all registers	
	pop ebp							;restore ebp
	ret 8							;clean the stack  

writeVal  ENDP

;------------------------------------------------------------------
; Procedure:	   Farewell
; Description:	   Display a farewell message.
; receives:        Offset of FinalMsg1, FinalMsg2
; returns:         Nothing (just displays farewell message)
; preconditions:   All values have to be passed by reference.
; registers used:  edx
;------------------------------------------------------------------
farewell PROC
	push	ebp					  ;by convention, save ebp into the stack
	mov		ebp, esp              ;set stack pointer

	call	CrLf
    mDisplayString [ebp+8]		  ;call macro to print farewell message
	call	CrLf
    mDisplayString [ebp+12]		  ;call macro to print farewell message
    call	CrLf
    call	CrLf
	mDisplayString [ebp+16]		  ;call macro to display cosmetic single space ;-)

	pop  ebp					  ;restore ebp
	ret  12						  ;empty stack 

farewell ENDP

END main

