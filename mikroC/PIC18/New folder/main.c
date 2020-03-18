
//#include <math.h>
//#include <stdio.h>
#include "lcd.h"
#include "ADC.h"
//#include "r_enc.h"


#define REA PORTB.B4 // Rotary encoder pin definition
#define REB PORTB.B5 //


//#define VREF               5      // refernce voltage [V]
//#define ADC_RES            1024   // 12 BIT ADC
//#define ADC_ARRAY_SIZE     4      //


sbit _rotoryCW   at RB0_bit;
sbit _rotoryCCW  at RB1_bit;
sbit _rotorySW   at RB2_bit;
sbit _swichOnOff at RA4_bit;

/*
 * Program flow related functions
 */
//unsigned char counter;    // It will hold the count of rotary encoder.
//unsigned int counter;       // It will hold the count of rotary encoder.
signed int count;         //this variable will incremented or decremented on encoder rotation
//char r_count[7];
//char text[7];
//int position;               // It will store the rotary encoder position.
//void sw_delayms(unsigned int d);
//int value[7];

/*
 * Functions
 */
//void system_init ();

void reverse(char* str, int len);
int intToStr(int x, char str[], int d);
void ftoa(float n, char* res, int afterpoint);
r_init(void);
void pbchange(void );


/*
const unsigned char  sinewave[256] = //256 values
{
0x80,0x83,0x86,0x89,0x8c,0x8f,0x92,0x95,0x98,0x9c,0x9f,0xa2,0xa5,0xa8,0xab,0xae,
0xb0,0xb3,0xb6,0xb9,0xbc,0xbf,0xc1,0xc4,0xc7,0xc9,0xcc,0xce,0xd1,0xd3,0xd5,0xd8,
0xda,0xdc,0xde,0xe0,0xe2,0xe4,0xe6,0xe8,0xea,0xec,0xed,0xef,0xf0,0xf2,0xf3,0xf5,
0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfc,0xfd,0xfe,0xfe,0xff,0xff,0xff,0xff,0xff,
0xff,0xff,0xff,0xff,0xff,0xff,0xfe,0xfe,0xfd,0xfc,0xfc,0xfb,0xfa,0xf9,0xf8,0xf7,
0xf6,0xf5,0xf3,0xf2,0xf0,0xef,0xed,0xec,0xea,0xe8,0xe6,0xe4,0xe2,0xe0,0xde,0xdc,
0xda,0xd8,0xd5,0xd3,0xd1,0xce,0xcc,0xc9,0xc7,0xc4,0xc1,0xbf,0xbc,0xb9,0xb6,0xb3,
0xb0,0xae,0xab,0xa8,0xa5,0xa2,0x9f,0x9c,0x98,0x95,0x92,0x8f,0x8c,0x89,0x86,0x83,
0x80,0x7c,0x79,0x76,0x73,0x70,0x6d,0x6a,0x67,0x63,0x60,0x5d,0x5a,0x57,0x54,0x51,
0x4f,0x4c,0x49,0x46,0x43,0x40,0x3e,0x3b,0x38,0x36,0x33,0x31,0x2e,0x2c,0x2a,0x27,
0x25,0x23,0x21,0x1f,0x1d,0x1b,0x19,0x17,0x15,0x13,0x12,0x10,0x0f,0x0d,0x0c,0x0a,
0x09,0x08,0x07,0x06,0x05,0x04,0x03,0x03,0x02,0x01,0x01,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x02,0x03,0x03,0x04,0x05,0x06,0x07,0x08,
0x09,0x0a,0x0c,0x0d,0x0f,0x10,0x12,0x13,0x15,0x17,0x19,0x1b,0x1d,0x1f,0x21,0x23,
0x25,0x27,0x2a,0x2c,0x2e,0x31,0x33,0x36,0x38,0x3b,0x3e,0x40,0x43,0x46,0x49,0x4c,
0x4f,0x51,0x54,0x57,0x5a,0x5d,0x60,0x63,0x67,0x6a,0x6d,0x70,0x73,0x76,0x79,0x7c
};
*/

void main()
{
     char *voltage = "00.0";
     char *current = "0.00";
     char *_prevVoltage = "00.0";
     char *_prevCurrent = "0.00";
     float currentLimit = 0.00;
     float voltageLimit = 00.0;
     
     char temp[15];
     
     unsigned char i;
     unsigned int a, b, result, OldResult;

     //float result;

     TRISA = 0x23;      // RA2 & RA5 as output
     TRISB = 0x0F;      // RB0~RB3 as input
     TRISC = 0x00;      // all output
     TRISD = 0x00;      // all output
     
     PORTB = 0x00;
     PORTC = 0x00;
     PORTD = 0x00;
     
     //ADCON1 = 0xC5;
     //ADCON0 = 0x41;     // RA0 & RA1 as analog input, RA3 as VREF+, all other as digital i/o
     //CMCON = 0x07;      // comperator disable

    lcd_init();
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
    r_init();
    ADC_Init();      //Initializes ADC Module
    
    
    //counter = 0;
    result = 0; 
    OldResult = 0;
    //Fup = 0;
    //Fdown = 0;
    
    while(1)
     {
         if (!_swichOnOff) 
         {
             while(!_swichOnOff);
             RA2_bit^=1;
         }
         if(count > 4095) count = 0;
         if(count < 0) count = 4095;
         if (RA2_bit)
         {
             PORTD = count;
             PORTC = (count>>8)&0x0F;

         }
         else
         {
             PORTD = 0;
             PORTC.B0 = 0;
             PORTC.B1 = 0;
             PORTC.B2 = 0;
             PORTC.B3 = 0;
         }
         //Delay_ms(10);

         a = ADC_Read(1); //Reading Analog Channel 1
         ftoa(a*0.0049,temp,2);
         Lcd_Out(2,2,temp);
         //Lcd_Out(2,2,current);
         lcd_puts(2, 6, "[I]");
         ftoa(currentLimit,temp,2);
         lcd_puts(2, 10, "[");
         Lcd_Out(2, 11, temp);
         lcd_puts(2, 15, "]");

         
       /*
         //Delay_ms(10);   //Delay
         _prevCurrent[0] = current[0];
         _prevCurrent[2] = current[2];
         _prevCurrent[3] = current[3];

         current[0]= result/1000+48;
         current[2]= (result/100)%10+48;
         current[3]= (result/10)%10+48;
         //current[4]= (result/10)%10+48;
         if ((_prevCurrent[0] != current[0]) || (_prevCurrent[2] != current[2]) || (_prevCurrent[3] != current[3]))
         {
           Lcd_Out(2,6,current);
           //lcd_puts(2, 11,  "[");
           //lcd_puts(2, 16,  "]");
         }*/
         //Lcd_Out(2,12,current);
         
         b = ADC_Read(0); //Reading Analog Channel 0
         ftoa((b*0.03-a*0.0049),temp,2);
         Lcd_Out(1,2,temp);
         //Lcd_Out(1,2,voltage);
         lcd_puts(1, 6, "[V]");
         ftoa(voltageLimit,temp,2);
         lcd_puts(1, 10, "[");
         Lcd_Out(1, 11, temp);
         lcd_puts(1, 15, "]");


         /*
         //Delay_ms(10);   //Delay
          _prevVoltage[0] = voltage[0];
          _prevVoltage[1] = voltage[1];
          _prevVoltage[3] = voltage[3];

         voltage[0]= result/1000+48;
         voltage[1]= (result/100)%10+48;
         voltage[3]= (result/10)%10+48;
         //current[4]= (result/10)%10+48;
         if ((_prevVoltage[0] != voltage[0]) || (_prevVoltage[1] != voltage[1]) || (_prevVoltage[3] != voltage[3]))
         {
           Lcd_Out(2,1,voltage);
         }
         //Lcd_Out(1,1,voltage);
         Delay_ms(10);
         */
     }
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
r_init(void)
{
    TRISB.B4=1; // set rotary encoder pins to input
    TRISB.B5=1;

    //Delay_ms(100); // Wait for UART module to stabilize

    OPTION_REG.B7 =0; // enable pullups
    INTCON.RBIF = 0; // clear the interrupt flag
    INTCON.RBIE = 1; // enable PORTB change interrupt
    INTCON.GIE = 1; // enable the global interrupt

    count=0;
    
    //IntToStr(count, text);
}
//
// **
//
/*void pbchange(void )
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
         }
         else if( state == 0x2)
         {
             count++; //decrement the count
         }
     }
     oldstate = state; // store the current state value to oldstate value this value will be used in next call

     PORTB = PORTB;    // read or Any read or write of PORTB,This will end the mismatch condition
     INTCON.RBIF = 0;  // clear the porb change intrrupt flag
}*/
//
//**
//
void interrupt(void)
{
     if(INTCON.RBIF==1) //check for PortB change interrupt
     {
         pbchange();    //call the routine
     }

}