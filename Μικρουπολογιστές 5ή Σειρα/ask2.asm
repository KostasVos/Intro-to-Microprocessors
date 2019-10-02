INCLUDE MACROS

DATA SEGMENT
	MSG1 DB "Z=$"
	MSG2 DB " W=$"
	MSG3 DB 0AH,ODH,"Z+W=$"
	MSG4 DB " Z-W=$"
ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
	
MAIN PROC FAR
	MOV AX,DATA_SEG
	MOV DS,AX
ADR0:
	PRINT_STR MSG1
	CALL HEX_KEYB	;Read first number, first digit
	MOV BL,16D
	MUL BL
	MOV BL,AL		;Multiply by 16, so it is MSB, store in BL
	CALL HEX_KEYB	;Read second digit LSB
	ADD BL,AL		;DL now contains full hex value of Z
	
ADR1:
	PRINT_STR MSG2
	CALL HEX_KEYB	;Read MSB of second number
	MOV BH, 16D
	MUL BH
	MOV BH,AL		;Same as before, now W in BH
	CALL HEX_KEYB
	ADD BH,AL
ADR2:
	MOV AL,BL		;First, add result
	ADD AL,BH
	MOV CX,4		;LOOP 4 times, each print a hex number
	PRINT_STR	MSG3
ADR3:
	ROL AX,4		;Setting 4 MSB's to print
	MOV DL,AL
	AND DL,0FH		;Mask first 4 bits, print routine uses D reg
	PUSH AX 		;Save A
	CALL PRINT_HEX
	POP AX
	LOOP ADR3
ADR4:
	MOV AL,BL
	SUB AL,BH		;Then, calculate Z-W (BL-BH)
	PRINT_STR MSG4
	MOV CX,4
ADR5:
	ROL AX,4		;Same as before
	MOV DL,AL
	AND DL,0FH		
	PUSH AX 		
	CALL PRINT_HEX
	POP AX
	LOOP ADR3
	JMP ADR0  		;Start over
MAIN ENDP
	
	
HEX_KEYB PROC NEAR	;modified, source from book page 378
	PUSH DX
IGNORE:
	READ
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
	

PRINT_HEX PROC NEAR
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
	
	
	
	
	
	
	
	
	