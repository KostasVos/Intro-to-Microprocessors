#include <avr/io.h>

char input,A,B,C,D,fout,f0,f1;

int main(void){

	DDRB = 0xFF; //output PORTB (0-1)
	DDRA = 0x00; //input PORTA (0-3)

	while(1){
	
		input = PINA & 0x0F; 
		A = input & 0x01; //isolating each one of
		B = input & 0x02; //the A,B,C,D bits
		B = B>>1;
		C = input & 0x04;
		C = C>>2;
		D = input & 0x08;
		D = B>>3;

		f1 = (A | B) & (C | D); //implementing f1

		f1 = f1<<1; //f1 corresponds to PORTB(1)
		f1 = f1 & 0x02; //isolating the bit needed

		f0 = ~(((A & B) & C) | ((~C)&D)); //implementing f2
		f0 = f0 & 0x01; //isolating the bit needed 
		fout = f0+f1;

		PORTB = fout; //f1 in PORTB(1) and f0 in PORTB(0)	
	
	}
	return 0;

}
