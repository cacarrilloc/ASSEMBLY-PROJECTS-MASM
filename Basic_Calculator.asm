TITLE Program #1     (program_1.asm)

; Author: Carlos Carrillo
; Course: CS_271                 Date: 01/14/2016
; Description: This is a MASM program:
;	a. Displays programmer's name and program title;
;	b. Display instructions for the user.
;	c. Prompt the user to enter two numbers.
;	d. Calculate the sum, difference, product, quotient and remainder.
;	e. Display the calculation results and a terminating message.

INCLUDE Irvine32.inc

.data
; Main variables
introName 	     BYTE "HI! I'M CARLOS CARRILLO. Nice to meet you!!", 0
introTask 	     BYTE "This is the Programming Assignment #1!", 0
introInstr 	     BYTE "Enter 2 numbers to calculate sum, difference, product, quotient and remainder!", 0
prompt_1 	          BYTE "Enter your 1st number: ", 0
prompt_2  	     BYTE "Enter your 2nd number: ", 0
int_1 	          DWORD ?   ;user's input #1
int_2 	          DWORD ?   ;user's input #
farewell			BYTE	"THE PROGRAM IS OVER! Have a great day!!!",0
equalSign		     BYTE	" = ", 0
sumResult			DWORD ?
sumSign			BYTE	" + ", 0
diffResult		DWORD ?
diffSign       	BYTE	" - ", 0
minuSign       	BYTE	"-", 0
prodResult		DWORD ?
prodSign  		BYTE	" * ", 0
quotResult		DWORD	?
quotSign  		BYTE	" / ", 0
remainResult		DWORD ?
remainSign		BYTE	"Remainder = ", 0

; Extra credit variables
extraPrompt		BYTE	"EC1: Would you like to do more calculations? YES= 1 / EXIT= 0: ", 0
extraExplain		BYTE	"**EC1: Loop to repeat the program until the user chooses to quit.**", 0

.code
 main PROC

; Print Extra Credit (EC) statement
     mov  edx, OFFSET extraExplain ;
     call WriteString
     call CrLf
     call CrLf

; Print the programmer's and project name 
     mov	edx, OFFSET introName
	call	WriteString
     call	CrLf
     call	CrLf
	mov	edx, OFFSET introTask
	call	WriteString
	call	CrLf

topLoop:                          ;top/return point for the loop

; Print and the instructions for user.
     call	CrLf                   
     mov  edx, OFFSET introInstr
	call	WriteString
	call	CrLf

; Get first integer
     call	CrLf
	mov	edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov	int_1, eax
     
; Get second integer
	mov	edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov	int_2, eax
     call	CrLf

; Calculations
	mov	eax, int_1              ;Addition operation
	add	eax, int_2
	mov	sumResult, eax
	
	mov	eax, int_1              ;Display the addition operation
	call	WriteDec
	mov	edx, OFFSET sumSign
	call	WriteString
	mov	eax, int_2
	call	WriteDec
	mov	edx, OFFSET equalSign
	call	WriteString
	mov	eax, sumResult
	call	WriteDec
	call	CrLf
     call	CrLf
                                  
     mov  eax, int_1              ;Difference operation            
     cmp  eax, int_2              ;Check if int_1 > or < int_2 to process the right result (- or +)
     jl   inverse                 ;Jump to inverse if int_1 < int_2
     mov  eax, int_1              ;Continue the sequence if int_1 > int_2
     sub  eax, int_2
     mov  diffResult, eax

     mov  eax, int_1              ;Display the difference operation
     call WriteDec
     mov  edx, OFFSET diffSign
     call WriteString
     mov  eax, int_2
     call WriteDec
     mov  edx, OFFSET equalSign
     call WriteString
     mov  eax, diffResult
     call WriteDec
     call	CrLf
     call	CrLf
     jmp  product

inverse:
     mov  eax, int_1              
     xchg eax, int_2              ;Swap variables to manage negative results
     mov int_1, eax
     
     mov  eax, int_1              ;Difference operation when int_1 < int_2
     sub  eax, int_2
     mov  diffResult, eax

     mov  eax, int_2              ;Display the difference operation
     call WriteDec
     mov  edx, OFFSET diffSign
     call WriteString
     mov  eax, int_1
     call WriteDec
     mov  edx, OFFSET equalSign
     call WriteString
     mov  edx, OFFSET minuSign
     call WriteString
     mov  eax, diffResult
     call WriteDec
     mov  eax, int_2              
     xchg eax, int_1              ;Swap variables back to initial input values
     mov  int_2, eax
     call	CrLf
     call	CrLf

product:
     mov  eax, int_1              ;Product  operation
     mov  ebx, int_2
     mul  ebx
     mov  prodResult, eax 

     mov  eax, int_1              ;Display the product operation
     call WriteDec
     mov  edx, OFFSET prodSign
     call WriteString
     mov  eax, int_2
     call WriteDec
     mov  edx, OFFSET equalSign
     call WriteString
     mov  eax, prodResult
     call WriteDec
     call	CrLf
     call	CrLf

     mov	edx, 0                  ;Quotient calculation
	mov	eax, int_1
	cdq
	mov	ebx, int_2
	cdq
	div	ebx
	mov	quotResult, eax
	mov	remainResult, edx

     mov  eax, int_1              ;Display the quotient operation
     call WriteDec
     mov  edx, OFFSET quotSign 
     call WriteString
     mov  eax, int_2
     call WriteDec
     mov  edx, OFFSET equalSign
     call WriteString
     mov  eax, quotResult
     call WriteDec
     call	CrLf
     call	CrLf

     mov	edx, OFFSET remainSign   ;Display the remainder
	call	WriteString
     mov	eax, remainResult
     call	WriteDec
     call	CrLf
     call	CrLf

     mov  edx, OFFSET farewell     ;Display a terminating message.
     call	WriteString
     call	CrLf
     call	CrLf

;EC1: Loop to repeat the program until the user chooses to quit.	

     mov	edx, OFFSET extraPrompt
	call	WriteString
	call	ReadInt
	cmp	eax, 1                    ;Jump to top when input is equal to 1
	je	topLoop			      

     exit                           ;exit to operating system

main ENDP
END main
