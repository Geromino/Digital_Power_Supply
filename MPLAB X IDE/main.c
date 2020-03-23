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


#define VREF               5      // refernce voltage [V]
#define ADC_RES            1024   // 12 BIT ADC
#define ADC_ARRAY_SIZE     4      //

#define KI  0.0048875      // current factor
#define KV  0.029768       // voltage factor

//#define KI  0.0049      // current factor
//#define KV  0.03        // voltage factor

#define _rotoryCW   RB0;
#define _rotoryCCW  RB1;
#define _rotorySW   RB2;
#define _outOnOff   RA4;

signed int count=0; //this variable will incremented or decremented on encoder rotation
char temp[15];
unsigned char i;
 
#define REA PORTBbits.RB4 // Rotary encoder pin definition
#define REB PORTBbits.RB5


/*
 * Functions
 */
//void r_init(void);
void pbchange(void);
void reverse(char* str, int len);
int intToStr(int x, char str[], int d);
void ftoa(float n, char* res, int afterpoint);

void main(void)
{
    //float result;
    char *voltage = "00.0";
    char *current = "0.00";
    char *_prevVoltage = "00.0";
    char *_prevCurrent = "0.00";
    float currentLimit = 0.00;
    float voltageLimit = 15.2;
     
    
    static __bit FOutOnOff;
    unsigned int a, b;
    signed int adc_count;
    float current_res;
    float voltage_res;
    float result;
    float OldResult;
    //unsigned int OldResult;
    
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
    GIE    = 0;    // enable the global interrupt
    PEIE   = 0;
    //ADCON1 = 0xC5;
    //ADCON0 = 0x41;     // RA0 & RA1 as analog input, RA3 as VREF+, all other as digital i/o
    //CMCON = 0x07;      // comperator disable
    
    lcd_init();
    lcd_clear();
    lcd_goto(0x0);
    lcd_puts("test");


   
    while(1)
    {
        RA2^=1;
        __delay_ms(500);
               
      
            
   }
    return;
}


// Reverses a string 'str' of length 'len'
void reverse(char* str, int len)
{
    int i = 0, j = len - 1, temp;
    while (i < j) {
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
        i++;
        j--;
    }
}
// Converts a given integer x to string str[].
// d is the number of digits required in the output.
// If d is more than the number of digits in x,
// then 0s are added at the beginning.
int intToStr(int x, char str[], int d)
{
    int i = 0;
    while (x) {
        str[i++] = (x % 10) + '0';
        x = x / 10;
    }

    // If number of digits required is more, then
    // add 0s at the beginning
    while (i < d)
        str[i++] = '0';

    reverse(str, i);
    str[i] = '\0';
    return i;
}
// Converts a floating-point/double number to a string.
void ftoa(float n, char* res, int afterpoint)
{
    // Extract integer part
    int ipart = (int)n;

    // Extract floating part
    float fpart = n - (float)ipart;

    // convert integer part to string
    int i = intToStr(ipart, res, 1);

    // check for display option after point
    if (afterpoint != 0) {
        res[i] = '.'; // add dot

        // Get the value of fraction part upto given no.
        // of points after dot. The third parameter
        // is needed to handle cases like 233.007
        fpart = fpart * pow(10, afterpoint);

        intToStr((int)fpart, res + i + 1, afterpoint);
    }
}
//
//**
//
/*
void r_init(void)
{
    TRISB.B4 = 1; // set rotary encoder pins to input
    TRISB.B5 = 1;

    //Delay_ms(100); // Wait for UART module to stabilize

    OPTION_REG.B7 = 0; // enable pullups
    INTCON.RBIF   = 0; // clear the interrupt flag
    INTCON.RBIE   = 1; // enable PORTB change interrupt
    INTCON.GIE    = 1; // enable the global interrupt
}
*/
//
//**
//
void pbchange(void)
{
    unsigned char state;
    static unsigned char oldstate; //static unsigned char oldstate; // this variable need to be static as it has to retain the value between calls
    __delay_ms(1); // delay for 1ms here for debounce
    //state = PORTB;
    //state = (state>>4)&0x03;    
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

    PORTB = PORTB; // read or Any read or write of PORTB,This will end the mismatch condition
    INTCONbits.RBIF = 0; // clear the porb change intrrupt flag
}
//
//
//
void __interrupt() ISR(void)
{
    if(RBIF==1)    //check for PortB change interrupt
    {
        //RA5^=1; 
        //__delay_ms(50);
        pbchange();    //call the routine
        RBIF = 0;
        //i = PORTB;
        
    }
}
 

