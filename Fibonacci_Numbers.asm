TITLE Fibonacci Numbers    (Project_2.asm)

; Author:	Carlos Carrillo
; Description: Write a program to calculate Fibonacci numbers.
;	• Display the program title and programmer’s name. Then get the user’s name, 
;      and greet the user.
;	• Prompt the user to enter the number of Fibonacci terms to be displayed. 
;      Advise the user to enter an integer in the range [1 .. 46].
;	• Get and validate the user input (n).
;	• Calculate and display all of the Fibonacci numbers up to and including the
;      nth term. The results should be displayed 5 terms per line with at least 5 
;      spaces between terms.
;	• Display a parting message that includes the user’s name, and terminate the 
;      program.

INCLUDE Irvine32.inc

.data
ECmsg     	BYTE	"**EC -> Do something incredible: Changing the font color to RED**", 0
programTitle	BYTE	"Program to Calculate Fibonacci Numbers", 0
myName		BYTE	"Programmed by Carlos Carrillo", 0
promptName	BYTE	"What's your name? ", 0
greetMsg       BYTE	"Hello, ", 0
byeMsg         BYTE	"Goodbye, ", 0
instruct1	     BYTE	"Enter the number of Fibonacci terms to be displayed", 0
instruct2 	BYTE	"Give the number as an integer in the range [1 .. 46].", 0
promptTerms	BYTE	"How many Fibonacci terms would you like to see?  ", 0
errorMsg       BYTE	"Sorry! Out of range. Enter a number in [1 .. 46]", 0
FinalMsg  	BYTE	"Results certified by Carlos Carrillo", 0
excMark    	BYTE	"!!", 0
userName		BYTE 32 DUP(0)
userNameCount  DWORD ?
userInput      DWORD ?   ;user's input
previous1      DWORD ?   ;first operand
previous2      DWORD ?   ;second operand 
currentCal     DWORD ?   ;current calculation
counterLine    DWORD ?   ;give a new line evey 5 elements
redColor       DWORD 12  ;color number corresponding to Red color
zero           BYTE "0", 0
one            BYTE "1", 0
space          BYTE "     ", 0 
UPBOUND = 47   ;computation limit

; Extra credit variable
promptColor	BYTE	"EC: Would you like to change the font color to RED? (YES=1 | NO=0):  ", 0

.code
main PROC
	mov   edx, OFFSET ECmsg         ;INTRODUCTION
     call  WriteString
     call  CrLf
     mov   edx, OFFSET programTitle  
     call  WriteString
     call  CrLf
     mov   edx, OFFSET myName
     call  WriteString
     call  CrLf
     call  CrLf

     mov   edx, OFFSET promptName    ;Getting user's name'
     call  WriteString
     mov	 edx, OFFSET userName	
	mov	 ecx, SIZEOF userName	  ;specify max characters
	call	 ReadString
	mov	 userNameCount, eax 
      
     mov   edx, OFFSET greetMsg      ;greeting the user
     call  WriteString
     mov   edx, OFFSET userName
     call  WriteString
     mov edx, OFFSET excMark
     call  WriteString
     call  CrLf
     call  CrLf

;EC: Changing the font color to RED in screen
     mov	 edx, OFFSET promptColor 
	call	 WriteString
	call	 ReadInt
	cmp	 eax, 1                    
	je	 redText                    ;jump when input = 1
     jmp   start        

redText:                              ;change font color
     mov   eax, 16                    ;mov eax, 12+(0*16) ; red color
	imul  eax, 16
	add   eax, redColor
	call  setTextColor
     
start:
     call  CrLf
     mov   edx, OFFSET instruct1      ;giving instructions to the user
     call  WriteString
     call  CrLf
     mov   edx, OFFSET instruct2
     call  WriteString
     call  CrLf
     call  CrLf

errorReturn:
     mov   edx, OFFSET promptTerms    ;getting input from the user
     call  WriteString
     call	 ReadInt
	mov	 userInput, eax
     cmp   eax, 1                ;input validation starts
     jl    displayError
     je    sequenceOne
     mov   eax, userInput
     cmp   eax, 2
     je    sequenceTwo
     mov   eax, userInput
     cmp   eax, UPBOUND
     jg    displayError
     jl    normalSequence

displayError:                     ;occur when (input < 1) or (input > 46) 
     call  CrLf
     mov   edx, OFFSET errorMsg
     call  WriteString
     call  CrLf
     call  CrLf
     jmp   errorReturn

sequenceOne:                      ;occur when input = 1
     call  CrLf
     mov   edx, OFFSET one
     call  WriteString
     jmp   final

sequenceTwo:                      ;occur when input = 2
     call  CrLf
     mov   edx, OFFSET one
     call  WriteString
     mov   edx, OFFSET space
     call  WriteString
     mov   edx, OFFSET one
     call  WriteString
     jmp   final

normalSequence:                   ;occur when (input > 1) or (input < 46)
     call  CrLf
     mov   edx, OFFSET one        ;display 1st number in the sequence
     call  WriteString
     mov   edx, OFFSET space      ;insert 5 spaces
     call  WriteString
     mov   edx, OFFSET one        ;display 2nd number in the sequence
     call  WriteString
     mov   edx, OFFSET space
     call  WriteString
     mov   previous1, 1           ;initialize first operand 
     mov   previous2, 1           ;initialize second operand
     mov   eax, userInput
     sub   eax, 2                 ;since the first 2 numbers are displayed already
     mov   ecx, eax               ;initialize accumulator
     mov   counterLine, 1         ;initialize counter
     
FiboLoop:                         ;calculate and display Fibonacci numbers 
     inc   counterLine            ;increment counter
     mov   eax, counterLine                    
     cmp   eax, 5                 ;give a new line evey 5 elements
     je    newLine                ;jump into nextLine when counterLine = 5
     mov   eax, previous1
     add   eax, previous2
     mov   currentCal, eax
     call  WriteDec
     mov   edx, OFFSET space      ;insert 5 spaces
     call  WriteString
     mov   eax, previous2
     mov   previous1, eax
     mov   eax, currentCal
     mov   previous2, eax   
loopInst:                         ;call loop instruction in any case
     loop  FiboLoop
     jmp   final

newLine:                          ;make the numbers be displayed in a new line
     call  CrLf
     mov   eax, previous1
     add   eax, previous2
     mov   currentCal, eax
     call  WriteDec
     mov   edx, OFFSET space      ;insert 5 spaces
     call  WriteString
     mov   eax, previous2
     mov   previous1, eax
     mov   eax, currentCal
     mov   previous2, eax
     mov   counterLine, 0         ;reset counter
     jmp   loopInst

final:                            ;last set of instructions
     call  CrLf
     call  CrLf
     mov   edx, OFFSET FinalMsg
     call  WriteString
     call  CrLf
     mov   edx, OFFSET byeMsg     ;say bye to the user
     call  WriteString
     mov   edx, OFFSET userName
     call  WriteString
     mov   edx, OFFSET excMark
     call  WriteString 
     call  CrLf
     call  CrLf
	exit	                        ;exit to operating system

main ENDP
END main
