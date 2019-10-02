.include "m16def.inc"
reset: ldi r24 , low(RAMEND) 	; initialize stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24
ser r24 			; initialize PORTB for output
out DDRB , r24
clr r27
out DDRA, r27

main:
clr r27

in r26,PINA
mov r20, r26
andi r20,1 			;isolating bit A in r20

lsr r26 			; logigal shift right is used for the next bit
mov r21, r26
andi r21,1 			; isolating bit B in r21

lsr r26
mov r22, r26
andi r22,1 			; isolating bit C in r22

lsr r26
mov r23, r26
andi r23,1 			; isolating bit D in r23


calculate_F1:

mov r24,r20
or r24,r21 			; (A + B)

mov r25,r22
or r25,r23 			; (C + D)

and r24,r25 			; (A+B)(C+D)

mov r27,r24
lsl r27 			; F1 corresponds to PORTB(1)

calculate_F0:


mov r24,r20
and r24,r21
and r24,r22 			; 'ABC'

mov r25, r22
com r25 			; computing C'
andi r25,1 			; isolating the lsb
and r25,r23 			; (C'D)

or r24,r25
com r24 			; (ABC + C'D)'
andi r24,1 			; isolating the lsb
add r27,r24 

out PORTB,r27 

rjmp main
