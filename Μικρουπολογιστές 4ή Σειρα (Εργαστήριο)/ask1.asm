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
push r24 ; 2 κύκλοι (0.250 μsec)
push r25 ; 2 κύκλοι
ldi r24 , low(998) ; φόρτωσε τον καταχ. r25:r24 με 998 (1 κύκλος - 0.125 μsec)
ldi r25 , high(998) ; 1 κύκλος (0.125 μsec)
rcall wait_usec ; 3 κύκλοι (0.375 μsec), προκαλεί συνολικά καθυστέρηση 998.375 μsec
pop r25 ; 2 κύκλοι (0.250 μsec)
pop r24 ; 2 κύκλοι
sbiw r24 , 1 ; 2 κύκλοι
brne wait_msec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
ret ; 4 κύκλοι (0.500 μsec)

wait_usec:
sbiw r24 ,1 ; 2 κύκλοι (0.250 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
nop ; 1 κύκλος (0.125 μsec)
brne wait_usec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
ret ; 4 κύκλοι (0.500 μsec)
