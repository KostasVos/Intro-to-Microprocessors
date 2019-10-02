DATA_SEG DATA SEGMENT
	TABLE 128 DUP(?)
	SPACE DB " "
DATA_SEG ENDS

CODE_SEG CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
MAIN PROC FAR
	MOV AX,DATA_SEG	
	MOV DS,AX
	MOV CX, 128	;First store all numbers
	LEA BX,TABLE	;Set counter and fetch address of table
LOOP1:
	MOV [BX],CX	
	INC BX		;Store numbers and increment BX
	LOOP LOOP1
	MOV CX, 128
	LEA SI,TABLE
	MOV AL,129	;AL contains min, initially set at 129
	MOV AH,0	;AH contains max, initially set at 0
	MOV DX,0	;D contains sum to be printed
LOOP2:
	MOV BX,[SI]	;Fetch a number
	INC SI
	TEST BL,01 	;Check if number is even
	JNZ EVEN	
	ADD DL,BL	;Add to sum if it is odd

EVEN:	CMP AL,BL	;Check if num<min
    	JGE  SKIP1	;If not, skip
	MOV AL,BL	;Else change AL
SKIP1:
	CMP BL,AH	;Similarily for max
        JGE  SKIP2
	MOV AH,BL

SKIP2:	LOOP LOOP2	;Loop for all numbers
	SAR DX,6	;Shift right six times, DX = DX/
	PRINT_HEX	;Print sum
	PRINT_STR SPACE
	MOV DL, AL	;Print min
	PRINT_HEX
	PRINT_STR SPACE
	MOV DL,AH	;Print max
	
	PRINT_HEX
MAIN ENDP


PRINT_HEX PROC NEAR	;Based on process from the book
	CMP DL,9
	JLE ADDR3
	ADD DL,37H
	JMP ADDR4
ADDR3:
	ADD DL,30H
ADDR4
	PRINT DL
	RET
PRINT_HEX ENDP

CODE_SEG ENDS
	END MAIN