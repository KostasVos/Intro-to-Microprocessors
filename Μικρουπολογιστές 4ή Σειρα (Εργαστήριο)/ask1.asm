.include "m16def.inc"
reset: ldi r24 , low(RAMEND) ; initialize stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24
ser r24 ; initialize PORTA for output
out DDRB , r24
clr r27
out DDRA, r27
ser r26 	
andi r26,1	;r26 = 00000001

left:
input1: in r27, PINA	;Check if A0 is pressed
	ror r27
	brcs input1			;If not, repeat until it's pressed
out PORTB , r26			;Turn on current led
ldi r24 , low(500) ; load r25:r24 with 500
ldi r25 , high(500) ; delay 1 second
rcall wait_msec
lsl r26 		; shift left once
cpi r26 , 128 	;compare with 128, B7 to be turned on
brlo left 	;if lower continue with left
rjmp right	;else go to right

right:
input2: in r27, PINA	;Check if A0 is pressed
	ror r27
	brcs input2
out PORTB , r26
ldi r24 , low(500) ; load r25:r24 with 500
ldi r25 , high(500) ; delay 1 second
rcall wait_msec
lsr r26 	; shift right once
cpi r26 , 1 ; compare with 1 similarily as before
brne right ; if not equal continue with right
rjmp left	;else go the other direction


wait_msec:
push r24 ; 2 ������ (0.250 �sec)
push r25 ; 2 ������
ldi r24 , low(998) ; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
ldi r25 , high(998) ; 1 ������ (0.125 �sec)
rcall wait_usec ; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
pop r25 ; 2 ������ (0.250 �sec)
pop r24 ; 2 ������
sbiw r24 , 1 ; 2 ������
brne wait_msec ; 1 � 2 ������ (0.125 � 0.250 �sec)
ret ; 4 ������ (0.500 �sec)

wait_usec:
sbiw r24 ,1 ; 2 ������ (0.250 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
brne wait_usec ; 1 � 2 ������ (0.125 � 0.250 �sec)
ret ; 4 ������ (0.500 �sec)
