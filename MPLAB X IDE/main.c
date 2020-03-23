/*
 * File:   main.c
 * Author: electronics
 *
 * Created on March 14, 2020, 12:29 AM
 */


#include <xc.h>
#include <math.h>
#include <stdio.h>
#include "lcd.h"
#include "ADC.h"
#include "config.h"


void main(void)
{

    
    TRISA = 0b00011011; //0x1B;      // RA2 & RA5 as output
    TRISB = 0xF0;      // RB0~RB3 as input
    TRISC = 0x00;      // all output
    TRISD = 0x00;      // all output
     
    PORTB = 0x00;
    PORTC = 0x00;
    PORTD = 0x00;
    
    nRBPU  = 0;    // enable pull-ups
    RBIF   = 0;    // clear the interrupt flag
    RBIE   = 1;    // enable PORTB change interrupt
    GIE    = 1;    // enable the global interrupt
    PEIE   = 1;



    while(1)
    {     
        RA2^=1;
        __delay_ms(1000);
            
   }
    return;
}


 

