INCLUDE MACROS
DATA_SEG SEGMENT
	TEMP DW ? ;Input temperature
	MSG_1 DB "START (Y,N):",0AH,0DH,"$"
	MSG_2 DB 0AH,0DH,"DISPLAY: D",0AH,0DH,
	DB "QUIT: N",0AH,0DH,"$"
	MSG_3 DB "T = ","$"
	MSG_ER DB "ERROR",0AH,0DH,"$"
	UNITS DB 020H,0F8H,"C",0AH,0DH,"$"
	UF_1 DB "Give a 3 digit hex number.",0AH,0DH,"$"
	BYE DB "BYE","$"
	NEW_LINE DB 0AH,0DH,"$"
DATA_SEG ENDS
CODE_SEG SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK
;-----------------------------------------------------------------
MAIN PROC FAR
	MOV AX,DATA_SEG
	MOV DS,AX ;DS = base address of DATA SEGMENT
START:
	PRINT_STR MSG_1
	PRINT_STR MSG_2
	KEEP_WORKING:
	READ
	CMP AL,"N" ;If 'N' was pressed, exit
	JE EXIT
	CMP AL,"D" ;If 'C' was pressed, proceed
	JNE KEEP_WORKING
	CALL READ_HEX_3 ;Read the temperature from "port"
CONVERT:
	MOV AX,TEMP ;AX = X
	CMP AX,4095 ;If X > 4095 (TEMP > 999.9)
	JG ERROR ;print "ERROR"
	CMP AX,3000 ;If X > 3000 (TEMP > 500)
	JG OVER_500 ;jump to OVER_500
	MOV BX,5
	MUL BX ;Y = 5 * X
	MOV BX,3
	DIV BX ;Y = Y / 3
	JMP READY
OVER_500:
	SUB AX,3000 ;X = X - 3000
	MOV BX,4999
	MUL BX ;Y = 4999 * X
	MOV BX,1095
	DIV BX ;Y = Y / 1095
	ADD AX,5000 ;Y = Y + 5000
READY:
	MOV TEMP,AX ;Replace the old value of TEMP
	;with the converted one
	PRINT_STR MSG_3 ;"T = "
	CALL PRINT_BCD ;Print the temperature in BCD
	PRINT_STR UNITS ;Print units and change line
	JMP KEEP_WORKING
ERROR:
	PRINT_STR MSG_ER
	JMP KEEP_WORKING
EXIT:
	PRINT_STR BYE
	MOV AX,4C00H
	INT 21H
MAIN ENDP
;-----------------------------------------------------------------
READ_HEX_3 PROC NEAR
PRINT_STR UF_1
MOV CL,12
MOV DX,0H
KEEP_READING:
READ ;Read digit
CMP AL,30H ;Make sure it is a number,
JL KEEP_READING ;or a letter between A and F,
CMP AL,3AH ;else keep reading
JL NUMBER
CMP AL,41H
JL KEEP_READING
CMP AL,46H
JG KEEP_READING
PUSH DX
PRINT AL ;Print the letter
POP DX
SUB AL,37H
JMP BOTTOM
NUMBER:
PUSH DX
PRINT AL ;Print the number
POP DX
SUB AL,30H
BOTTOM:
MOV AH,0H ;AH = 0
SUB CL,4 ;CL -= 4
ROL AX,CL ;Rotate left for CL bits
OR DX,AX
CMP CL,0 ;If CL = 0 stop reading
JNE KEEP_READING
MOV TEMP,DX ;Store the number in memory
PRINT_STR NEW_LINE ;new line
RET
READ_HEX_3 ENDP
;-----------------------------------------------------------------
PRINT_BCD PROC NEAR
	MOV AX,TEMP ;AX = TEMP
	MOV CX,0 ;digit COUNTER
	MOV BX,0AH ;BX = 10
	DIVIDE:
	MOV DX,0 ;DX = 00H
	DIV BX ;AX/10 = AX
	PUSH DX ;Push remainder
	INC CX ;CX += 1
	CMP AX,0 ;If AX = 0 stop
	JNE DIVIDE
	NEXT_DIGIT:
	POP DX ;Pop digit
	ADD DX,30H ;Convert it to ASCII
	CMP CX,1
	JNE SKIP
	PUSH DX
	PRINT "."
	POP DX
	SKIP:
	PRINT DL ;Print it
	LOOP NEXT_DIGIT ;Loop until CX = 0
	RET
PRINT_BCD ENDP
;-----------------------------------------------------------------
CODE_SEG ENDS
END MAIN