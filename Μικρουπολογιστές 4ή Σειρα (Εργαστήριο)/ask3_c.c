#include <avr/io.h>
char x;

int main(void)
{
	DDRA=0xFF; //output
	DDRC=0x00; //input


	x = 1; // initialization for first LED


	while(1){		
	
		if ((PINC & 0x01) == 1){ // push-button SW0 check
			while ((PINC & 0x01) == 1); 
			if (x==128) // overflow check
				x = 1;
			else
				x = x<<1; // left shift logical
		}

		if ((PINC & 0x02) == 2){ // push-button SW1 check
			while ((PINC & 0x02) == 2); 
			if (x==1) // overflow check
				x = 128;
			else
				x = x>>1; // right shift logical
		}

		if ((PINC & 0x04) == 4){ // push-button SW3 check
			while ((PINC & 0x04) == 4); 
			x=128;
			
		}
		
		if ((PINC & 0x08) == 8){ // push-button SW4 check
			while ((PINC & 0x08) == 8); 
			x=1;
			
		}
		

		PORTA = x; // Έξοδος σε PORTA
	}
	return 0;
}

