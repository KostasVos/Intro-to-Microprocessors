READ MACRO 
    MOV AH,8
    INT 21H
ENDM

PRINT MACRO CHAR
    MOV DL,CHAR
    MOV AH,2
    INT 21H
ENDM    

PRINT_STR MACRO STRING
    MOV DX,OFFSET STRING
    MOV AH,9
    INT 21H
ENDM

DATA_SEG SEGMENT
    TABLE DB 20 DUP(20) ;ston pinaka TABLE
    NL DB 0AH,0DH,'$'   ;apothikeuontai oi 20 
DATA_SEG ENDS           ;haraktires

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX
    
START:   
        MOV BX,0        ;metritis twn stoixeiwn
  GEMISMA_TABLE:        ;pou apothikeuontai ston
        CMP BX,20              ;TABLE
        JE EMFANISH_STOIXEIWN  ;an xeperasoun ta 20
        READ                   ;emfanizontai ta 
        CMP AL,'='      ;apotelesmata stin othoni
        JE TELOS
        CMP AL,13
        JE IF_ENTER
        CMP AL,'0'        ;eleghos an o haraktiras
        JL GEMISMA_TABLE  ;einai metaxy 0-9 h a-z
        CMP AL,'9'
        JLE IF_0_TO_9
        CMP AL,'a'
        JL GEMISMA_TABLE
        CMP AL,'z'
        JLE IF_a_TO_z
        JMP GEMISMA_TABLE
        
  IF_ENTER:               ;an patithei ENTER kai yparhoun
        CMP BX,0          ;stoixeia ston pinaka,
        JE GEMISMA_TABLE        ;emfanizontai stin othoni
        JMP EMFANISH_STOIXEIWN
        
  IF_0_TO_9: 
        PRINT AL
        MOV TABLE[BX],AL
        INC BX
        JMP GEMISMA_TABLE
        
  IF_a_TO_z:
        PRINT AL
        SUB AL,32
        MOV TABLE[BX],AL
        INC BX
        JMP GEMISMA_TABLE
        
  EMFANISH_STOIXEIWN:
        PRINT_STR NL    ;ta apotelesmata emfanizontai sthn
        MOV CX,BX       ;epomeni grammi
        MOV BX,0
        PRINT_ST:
            CMP BX,CX     ;eleghoume kathe stigmh poio
            JE TELOS_PRINT   ;stoixeio emfanizetai, molis 
            MOV AL,TABLE[BX] ;o metritis ginei megalyteros
            PRINT AL     ;tou arithmou twn stoixeiwn tou
            INC BX       ;pinaka, metavainoume stin 
            JMP PRINT_ST ;TELOS_PRINT
        
        TELOS_PRINT:
            PRINT_STR NL  ;allagh grammis kai anamonh gia
            MOV BX,0      ;plhktrologisi newn haraktirwn
            JMP GEMISMA_TABLE 
  TELOS:
            
MAIN ENDP

CODE_SEG ENDS
    END MAIN