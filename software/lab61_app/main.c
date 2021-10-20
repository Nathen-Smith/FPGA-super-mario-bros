// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng
#define SHOW_LED = 0;

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;
	volatile unsigned int *KEY1_PIO = (unsigned int*)0x50;

	*LED_PIO = 0; //clear all LEDs
    // uncomment for led blinking
//	while ( (1+1) != 3) //infinite loop
//	{
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO |= 0x1; //set LSB
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO &= ~0x1; //clear LSB
//	}

	while (1) {
		if (*KEY1_PIO == 0x0) {
			//hang execution until button released (self loop)
			while (*KEY1_PIO == 0x0);
			// released button
			// add to sum
			*LED_PIO = (*LED_PIO + *SW_PIO) % 256;
		}
	}

	return 1; //never gets here
}
