DATA SEGMENT
	MSG1 DB "Enter first digit=$"
	MSG2 DB 0AH,ODH,"Enter second digit=$"
	EQUALS DB " = $"
	SPACE DB 0AH,0DH
ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
	
MAIN PROC FAR
	MOV AX,DATA_SEG
	MOV DS,AX
ADR0:
	PRINT_STR MSG1
	CALL HEX_KEYB	;Read first number, first digit
	CMP AL,'T'
	JE QUIT
	MOV BL,16D
	MUL BL
	MOV BL,AL		;Multiply by 16, so it is MSB, store in BL
	CALL HEX_KEYB	;Read second digit LSB
	ADD BL,AL		;DL now contains full hex value of Z
PRINT_DIGITS:
	PRINT_HEX
	PRINT_STR EQUALS
	PRINT_DEC
	PRINT_STR EQUALS
	PRINT_OCT
	PRINT_STR EQUALS
	PRINT_STR SPACE
	JMP ADR0
QUIT:
	EXIT
            
MAIN ENDP

	
	
HEX_KEYB PROC NEAR	;modified, can also read 'T' source from book page 378
	PUSH DX
IGNORE:
	READ
	CMP AL,'T'
	JE ADDR2
	CMP AL,30H
	JL IGNORE
	CMP AL,39H
	JG ADDR1
	PUSH AX
	PRINT AL
	POP AX
	SUB AL,30H
	JMP ADDR2
ADDR1:
	CMP AL,'A'
	JL IGNORE
	CMP AL,'F'
	JG IGNORE
	PUSH AX
	PRINT AL
	POP AX
	SUB AL,37H
ADDR2:
	POP DX
	RET
HEX_KEYB ENDP
	

PRINT_HEX PROC NEAR	;Same as book
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
	
	

PRINT_BIN PROC NEAR
	PUSH DX		;Save registers used
	PUSH CX
	PUSH AX
	MOV AX,DX
	MOV CX,8	;Loop 8 times
LB1:	
				;We want the digits to be printed MSB->LSB
	ROL DL,1	;Shift left once to get MSB to LSB's position
	MOV AL,DL	
	AND DL,01H	;Isolate first digit
	PRINT_HEX	;Print it
	MOV DL,AL
	LOOP LB1
	POP AX
	POP CX
	POP DX
	RET
PRINT_BIN ENDP 


PRINT_OCT PROC NEAR
	PUSH DX		;Save registers
	PUSH CX
	PUSH AX
	MOV AX,DX
	;There are 8 digits, we want them printed in groups of 3
	
	ROL DL,2	;First get the 2 MSB's to LSB to be printed
	AND DL,03H	;Keep only first two bits
	PRINT_HEX

	MOV DL,AL	;Now get the next 3 bits to be printed
	ROL DL,3
	MOV AL,DL
	AND DL,07H	;Keep first 3 bits
	PRINT_HEX

	MOV DL,AL	;Same as before, final 3 bits
	ROL DL,3
	AND DL,07H
	PRINT_HEX
	POP AX
	POP CX
	POP DX
	RET
PRINT_OCT ENDP 
	
	
PRINT_DEC PROC NEAR	;From the book, page 381
	PUSH AX
	PUSH BX
	PUSH DX
	MOV CX, 0		;Counter = 0    
	MOV AX, DX 
ADDR5: 	MOV DX, 0 	
	MOV BX,10 		
	DIV BX  		;Divide by 10
	PUSH DX 		;Save remainder on stack
	INC CX   		;One more digit
	CMP AX, 0 		;If remainder==0 no more digits
	JNE ADDR5
ADDR6:
	POP DX   
	ADD DX,30H 		;Find ascii and print
	PRINT DL		
	LOOP ADDR6		;Loop for all digits
	POP DX
	POP BX
	POP AX
	RET
PRINT_DEC ENDP 


CODE_SEG ENDS
    END MAIN
	
	
	
	
	
	
	
	
	
	
	
	