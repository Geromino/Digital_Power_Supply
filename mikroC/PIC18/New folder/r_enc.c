

#include "r_enc.h"

signed int count=0; //this variable will incremented or decremented on encoder rotation
char text[7];

#define REA PORTB.B4 // Rotary encoder pin definition
#define REB PORTB.B5


void pbchange(void )
{
     unsigned char state;
     static unsigned char oldstate; // this variable need to be static as it has to retain the value between calls
     delay_ms(1); // delay for 1ms here for debounce
     state= (REB<<1 | REA); // combine the pin status and assign to state variable
     if(oldstate==0x0)
     {
         if( state ==0x1)
         {
             count--; //decrement the count
             //lcd_out(1,8,count);
         }
         else if( state == 0x2)
         {
             count++; //decrement the count
             //Lcd_Out(1,8,count);
         }
     }

     oldstate = state; // store the current state value to oldstate value this value will be used in next call

     PORTB = PORTB;    // read or Any read or write of PORTB,This will end the mismatch condition
     INTCON.RBIF = 0;  // clear the porb change intrrupt flag
}
void interrupt(void)
{
     if(INTCON.RBIF==1) //check for PortB change interrupt
     {
         pbchange();    //call the routine
     }

}

//void main() {
r_init()
{
    TRISB.B4=1; // set rotary encoder pins to input
    TRISB.B5=1;

    Delay_ms(100); // Wait for UART module to stabilize

    OPTION_REG.B7 =0; // enable pullups
    INTCON.RBIF = 0; // clear the interrupt flag
    INTCON.RBIE = 1; // enable PORTB change interrupt
    INTCON.GIE = 1; // enable the global interrupt

IntToStr(count, text);
Lcd_Out(2,1,text);

}