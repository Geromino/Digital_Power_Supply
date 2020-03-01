        /*
 * File:   main.c
 * Author: Sourav Gupta
 *
 * Created on 18 Dec 2018, 18:57
 */

/*
 * Configuration Related settings. Specific for microcontroller unit.
 */
#pragma config FOSC = HS        // Oscillator Selection bits (HS oscillator)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON       // Brown-out Reset Enable bit (BOR enabled)
#pragma config LVP = OFF         // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3/PGM pin has PGM function; low-voltage programming enabled)
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
#pragma config WRT = OFF        // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF         // Flash Program Memory Code Protection bit (Code protection off)
#define _XTAL_FREQ 20000000
/*
 * System Header files inclusions
 */

#include <xc.h>
//#include <string.h>
#include <stdlib.h>
#include "supporting c files/lcd.h"

#define Encoder_SW PORTDbits.RD2
#define Encoder_DT PORTDbits.RD3
#define Encoder_CLK PORTCbits.RC4

/*
 * Program flow related functions
 */
int counter; // It will hold the count of rotary encoder.
int position; // It will store the rotary encoder position.
void sw_delayms(unsigned int d);
int value[7];

/*
 * System Init Function
 */

void system_init ();

/* Main function single Thread*/
void main(void) {
    system_init();
    lcd_puts ("Circuit Digest");
    lcd_com(0xC0);
    counter = 0;
    while(1){
        lcd_com(0xC0);
        if (Encoder_SW == 0){
            sw_delayms(20);
            if (Encoder_SW == 0){
                //lcd_com(1);
                //lcd_com(0xC0);
                lcd_puts ("switch pressed");
//                itoa(counter, value, 10);
//                lcd_puts(value);
            }
        }
       if (Encoder_CLK != position){
            if (Encoder_DT != position){
               // lcd_com (0x01);
                counter++;
                lcd_com (0xC0);
                lcd_puts("                ");
                lcd_com (0xC0);
                lcd_bcd(1,counter);
            }
            else{
               // lcd_com (0x01);
                lcd_com (0xC0);
                counter--;
                lcd_puts("                ");
                lcd_com (0xC0);
                lcd_bcd(1,counter);
                //lcd_puts("Left");
            }
        }
        position = Encoder_CLK;

}

    return;
}

void sw_delayms(unsigned int d){
int x, y;
for(x=0;x<d;x++)
for(y=0;y<=1275;y++);
}

void system_init(){
    TRISB = 0x00; // PORT B as output, This port is used for LCD
    TRISDbits.TRISD2 = 1;
    TRISDbits.TRISD3 = 1;
    TRISCbits.TRISC4 = 1;
    lcd_init(); // This will Initialize the LCD
    position = Encoder_CLK;// Sotred the CLK position on system init, before the while loop start.
}